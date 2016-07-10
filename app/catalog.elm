import Html exposing (Html, div, span, input, text, img)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import Dict
import Json.Decode as Json exposing (..)
import Http
import Task
import Navigation

import Routing

main : Program Never
main =
  Navigation.program Routing.parser
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }

type alias CoverImage = Maybe (Dict.Dict String String)

type alias CatalogItem =
  { name : String
  , description : String
  , tags : List String
  , url : Maybe String
  , coverImage : CoverImage
  }

type alias CatalogSection =
  { name : String
  , items : List CatalogItem
  , coverImage : CoverImage
  }

type alias CatalogData =
  { name : String
  , thumbnailSizes : List String
  , sections : List CatalogSection
  }

type alias Model =
  { route : Routing.Route
  , catalogUrl : String
  , catalogData : Maybe CatalogData
  }

init : Result String Routing.Route -> (Model, Cmd Msg)
init result =
  let
    catalogJsonUrl = "catalog/catalog.json"
    currentRoute = Routing.routeFromResult result
  in
    (Model currentRoute catalogJsonUrl Nothing, getCatalog catalogJsonUrl)

urlUpdate : Result String Routing.Route -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  let
    currentRoute =
      Routing.routeFromResult result
  in
    ({ model | route = currentRoute }, Cmd.none)

type Msg
  = CatalogFetchError Http.Error
  | CatalogFetchSucceeded CatalogData
  | ShowSection String

decodeItem : Json.Decoder CatalogItem
decodeItem =
  Json.object5 CatalogItem ("name" := string) ("description" := string) ("tags" := list string) (maybe ("url" := string)) (maybe ("coverImage" := (dict string)))

decodeSection : Json.Decoder CatalogSection
decodeSection =
  Json.object3 CatalogSection ("name" := string) ("items" := list decodeItem) (maybe ("coverImage" := (dict string)))

decodeCatalog : Json.Decoder CatalogData
decodeCatalog =
  Json.object3 CatalogData ("name" := string) ("thumbnailSizes" := list string) ("sections" := list decodeSection)

getCatalog : String -> Cmd Msg
getCatalog catalogUrl =
  Task.perform CatalogFetchError CatalogFetchSucceeded (Http.get decodeCatalog (catalogUrl))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    CatalogFetchError error ->
      (Debug.log "error!" model, Cmd.none)

    CatalogFetchSucceeded catalogData ->
      ({ model | catalogData = Just catalogData }, Cmd.none)

    ShowSection sectionName ->
      (model, Navigation.modifyUrl ("#section/" ++ sectionName))

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

coverImage : { a | coverImage : CoverImage } -> String -> String -> Html Msg
coverImage element thumbnailSize defaultImage =
  let imageUrl
        = case element.coverImage of
            Just imageData ->
              case (Dict.get thumbnailSize imageData) of
                Just data ->
                  "/catalog/" ++ data
                Nothing ->
                  defaultImage
            Nothing ->
              defaultImage
  in
    img [ src imageUrl ] []

highlightedItemView : CatalogItem -> Html Msg
highlightedItemView item =
  div [ class "highlighted-item" ]
    [ coverImage item "64x64" "/images/default-item.png"
    , span [ class "highlighted-item-text" ] [ text item.name ]
    ]

catalogSectionView : CatalogSection -> Html Msg
catalogSectionView section =
  div [ class "section-preview-container" ]
    [ div [ class "section-name", onClick (ShowSection section.name) ] [ text section.name ]
    , div [ class "section-preview" ]
        [ div [ class "section-badge" ]
            [ coverImage section "128x128" "/images/default-section.png" ]
        , div [ class "highlighted-items" ]
                (List.map highlightedItemView section.items)
        ]
    ]

catalogView : CatalogData -> Html Msg
catalogView catalog =
  div []
    (List.map
         (\section -> catalogSectionView section)
         catalog.sections)

catalogIndexView : Model -> Html Msg
catalogIndexView model =
    case model.catalogData of
      Just data ->
        catalogView data
      Nothing ->
        div [] [ text "Loading…" ]

view : Model -> Html Msg
view model =
  case model.route of
    Routing.CatalogIndex ->
      catalogIndexView model
    Routing.SectionIndex sectionName ->
      div []
        [ text ("Here I'll show section " ++ sectionName)
        ]
    Routing.NotFoundRoute ->
      div []
        [ text "404 Not Found"
        ]
