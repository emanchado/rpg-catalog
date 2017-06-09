module Update exposing (..)

import Navigation
import Routing
import Models exposing (..)
import Messages exposing (..)
import SectionPage.Model
import SectionPage.Update


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateLocation newLocation ->
      ( { model | route = Routing.parseLocation newLocation }, Cmd.none )

    CatalogFetch (Err error) ->
      ( model, Cmd.none )

    CatalogFetch (Ok catalogData) ->
      ( { model | catalog = Just catalogData }, Cmd.none )

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
