module Actions exposing (..)

import Http
import Navigation

import Routing
import Models exposing (..)

type Msg
  = CatalogFetchError Http.Error
  | CatalogFetchSucceeded CatalogData
  | ShowSection Int
  | ShowItem Int

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
      ({ model | catalogData = Just catalogData }, Cmd.none)

    ShowSection sectionName ->
      (model, Navigation.modifyUrl ("#section/" ++ (toString sectionName)))

    ShowItem itemName ->
      (model, Navigation.modifyUrl ("#item/" ++ (toString itemName)))
