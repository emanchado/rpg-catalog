module Update exposing (..)

import Navigation

import Routing
import Models exposing (..)
import Messages exposing (..)
import SectionPage.Model
import SectionPage.Update

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
      (model, Navigation.newUrl "#/")

    ShowSection sectionId ->
      ({ model | sectionPage = SectionPage.Model.init model.catalog}
       , Navigation.newUrl ("#section/" ++ (toString sectionId)))

    ShowItem itemId ->
      (model, Navigation.newUrl ("#item/" ++ (toString itemId)))

    SectionPage msg ->
      case SectionPage.Update.update msg model.sectionPage of
        (updatedSectionPage, cmd) ->
          ({ model | sectionPage = updatedSectionPage }, Cmd.map SectionPage cmd)
