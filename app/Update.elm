module Update exposing (..)

import Json.Decode
import Navigation

import Routing
import Models exposing (..)
import CatalogModels exposing (serializableCatalog)
import Messages exposing (..)
import SectionPage.Model
import SectionPage.Update
import Ports exposing (indexCatalog, parseSearchIndex)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateLocation newLocation ->
      ( { model | route = Routing.parseLocation newLocation }, Cmd.none )

    CatalogFetch (Err error) ->
      ( model, Cmd.none )

    CatalogFetch (Ok catalogData) ->
      ( { model | catalog = Just catalogData }
      , indexCatalog <| serializableCatalog catalogData
      )

    UpdateSearchTerms newSearchTerms ->
      ( { model | searchTerms = newSearchTerms }
      , Cmd.none
      )

    GoToSearch ->
      ( model
      , Navigation.newUrl <| "#/search"
      )

    PerformSearch searchTerms ->
      ( { model | searchTerms = searchTerms }
      , Navigation.newUrl <| "#/search"
      )

    ShowCatalog ->
      ( model, Navigation.newUrl "#/" )

    ShowSection sectionId ->
      ( { model | sectionPage = SectionPage.Model.init model.catalog }
      , Navigation.newUrl ("#section/" ++ (toString sectionId))
      )

    ShowItem itemId ->
      ( model, Navigation.newUrl ("#item/" ++ (toString itemId)) )

    SectionPage msg ->
      case SectionPage.Update.update msg model.sectionPage of
        (updatedSectionPage, cmd) ->
          ( { model | sectionPage = updatedSectionPage }
          , Cmd.map SectionPage cmd
          )

    IndexCatalogSuccess rawIndex ->
      case model.catalog of
        Just catalog ->
          let
            parseResult = Json.Decode.decodeValue (parseSearchIndex catalog) rawIndex
          in
            case parseResult of
              Ok newSearchIndex ->
                ( { model | searchIndex = Just newSearchIndex }
                , Cmd.none
                )
              _ ->
                ( model, Cmd.none )
        Nothing ->
          ( model, Cmd.none )
