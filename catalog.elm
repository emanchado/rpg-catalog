import Html.App as App
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (type', value)
import Html.Events exposing (onClick)
import String
import Http
import Task
import Json.Decode as Json exposing (..)

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias CatalogSection =
  { name : String
  , tags : List String
  }

type alias CatalogData =
  { name : String
  -- , sections : List CatalogSection
  , thumbnailSizes : List String
  }

type alias Model =
  { catalogUrl : String
  , catalogData : Maybe CatalogData
  }

init : (Model, Cmd Msg)
init =
  (Model "http://demiurgo.org/tmp/catalog/catalog.json" Nothing, Cmd.none)

type Msg
  = GetCatalog
  | CatalogFetchError Http.Error
  | CatalogFetchSucceeded (String, List String)

decodeCatalog : Json.Decoder (String, List String)
decodeCatalog =
  Json.object2 (,) ("name" := string) ("thumbnailSizes" := list string)

getCatalog : String -> Cmd Msg
getCatalog catalogUrl =
  Task.perform CatalogFetchError CatalogFetchSucceeded (Http.get decodeCatalog (catalogUrl))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetCatalog ->
      (model, getCatalog model.catalogUrl)

    CatalogFetchError error ->
      (model, Cmd.none)

    CatalogFetchSucceeded (catalogName, catalogThumbnailSizes) ->
      ({ model | catalogData = Just (CatalogData catalogName catalogThumbnailSizes) }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

catalogView : Model -> Html Msg
catalogView model =
  div []
    [ text (case model.catalogData of
              Just data ->
                data.name
              Nothing ->
                "nada")
    , text " Thumbnail sizes: "
    , text (case model.catalogData of
              Just data ->
                String.join ", " data.thumbnailSizes
              Nothing ->
                "[]")
    ]

view : Model -> Html Msg
view model =
  div []
    [ catalogView model
    , input [ type' "button", Html.Attributes.value "Get catalog", onClick GetCatalog ] []
    ]
