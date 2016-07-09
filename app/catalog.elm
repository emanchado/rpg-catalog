import Html.App as App
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (type', value)
import Html.Events exposing (onClick)
import String
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

type alias CatalogItem =
  { name : String
  , description : String
  , tags : List String
  , url : Maybe String
  , coverImage : Maybe (Dict.Dict String String)
  }

type alias CatalogSection =
  { name : String
  , items : List CatalogItem
  , coverImage : Maybe (Dict.Dict String String)
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
  (Model "http://demiurgo.org/tmp/catalog/catalog.json" Nothing, Cmd.none)

type Msg
  = GetCatalog
  | CatalogFetchError Http.Error
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
    GetCatalog ->
      (model, getCatalog model.catalogUrl)

    CatalogFetchError error ->
      (Debug.log "error!" model, Cmd.none)

    CatalogFetchSucceeded catalogData ->
      ({ model | catalogData = Just catalogData }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

sectionView : CatalogSection -> Html Msg
sectionView section =
  div []
    [ text ("Section: " ++ section.name)
    , text (" Cover image: "
              ++ case section.coverImage of
                   Just imageData ->
                     (toString (Dict.size imageData))
                     ++ " sizes; original: "
                     ++ case (Dict.get "original" imageData) of
                          Just data ->
                            data
                          Nothing ->
                            "no original?"
                   Nothing ->
                     "no cover image")
    ]

catalogView : CatalogData -> Html Msg
catalogView catalog =
  div []
    [ div []
        [ text " Thumbnail sizes: "
        , text (String.join ", " catalog.thumbnailSizes)
        ]
    , div []
        [ text " Sections: "
        , div []
          (List.map (\section -> sectionView section) catalog.sections)
        ]
    ]

view : Model -> Html Msg
view model =
  div []
    [ case model.catalogData of
        Just data ->
          catalogView data
        Nothing ->
          input [ type' "button", Html.Attributes.value "Get catalog", onClick GetCatalog ] []
    ]
