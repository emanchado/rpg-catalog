module ItemDetailView exposing (view)

import Dict
import Html exposing (Html, div, span, input, text, img)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)

import Models exposing (..)
import Actions exposing (..)
import ViewUtils

view : CatalogData -> Int -> Html Msg
view catalog itemId =
  div []
    [ text ("Show item: " ++ (toString itemId)) ]
