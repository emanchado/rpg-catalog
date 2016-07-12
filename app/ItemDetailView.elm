module ItemDetailView exposing (view)

-- import Dict
import Html exposing (Html, div, span, a, input, text, img)
import Html.Attributes exposing (class, src, href)
import Html.Events exposing (onClick)

import Models exposing (..)
import Actions exposing (..)
import ViewUtils
import ModelUtils

view : CatalogData -> Int -> Html Msg
view catalog itemId =
  case ModelUtils.getSectionItem catalog itemId of
    Just (section, item) ->
      div []
        [ div [] [ text ("Show item: " ++ (toString itemId)) ]
        , a [ href ("#section/" ++ (toString section.id))
            , onClick (ShowSection section.id)
            ]
            [ text "Back to section" ]
        ]
    Nothing ->
      div []
        [ text ("Item " ++ (toString itemId) ++ " does not exist") ]
