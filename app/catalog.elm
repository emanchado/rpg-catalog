import Html.App as App
import Html exposing (Html, div, span, input, text, img)
import Html.Attributes exposing (src, class)
import Dict
import Json.Decode as Json exposing (..)
import Http
import Task

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
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
  { catalogUrl : String
  , catalogData : Maybe CatalogData
  }

init : (Model, Cmd Msg)
init =
  let
    url = "catalog/catalog.json"
  in
    (Model url Nothing, getCatalog url)

type Msg
  = CatalogFetchError Http.Error
  | CatalogFetchSucceeded CatalogData

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
    [ div [ class "section-name" ] [ text section.name ]
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

view : Model -> Html Msg
view model =
  div []
    [ case model.catalogData of
        Just data ->
          catalogView data
        Nothing ->
          div [] [ text "Loading…" ]
    ]
