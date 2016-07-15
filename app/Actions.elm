module Actions exposing (..)

import Http
import Navigation

import Routing
import Models exposing (..)
import CatalogModels exposing (Catalog)
import SectionPage.Model
import SectionPage.Update
import SectionPage.Messages

type Msg
  = CatalogFetchError Http.Error
  | CatalogFetchSucceeded Catalog
  | ShowCatalog
  | ShowSection Int
  | ShowItem Int
  | SectionPage SectionPage.Messages.Msg

urlUpdate : Result String Routing.Route -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  let
    currentRoute =
      Routing.routeFromResult result
  in
    ({ model | route = currentRoute }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    CatalogFetchError error ->
      (Debug.log "error!" model, Cmd.none)

    CatalogFetchSucceeded catalogData ->
      ({ model | catalog = Just catalogData }, Cmd.none)

    ShowCatalog ->
      (model, Navigation.modifyUrl "#/")

    ShowSection sectionId ->
      ({ model | sectionPage = SectionPage.Model.init model.catalog}
       , Navigation.modifyUrl ("#section/" ++ (toString sectionId)))

    ShowItem itemId ->
      (model, Navigation.modifyUrl ("#item/" ++ (toString itemId)))

    SectionPage msg ->
      case SectionPage.Update.update msg model.sectionPage of
        (updatedSectionPage, cmd) ->
          ({ model | sectionPage = updatedSectionPage }, Cmd.map SectionPage cmd)
