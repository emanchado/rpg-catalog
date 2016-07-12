module ItemDetailView exposing (view)

-- import Dict
import Html exposing (Html, h2, div, span, a, input, text, img)
import Html.Attributes exposing (class, src, href)
import Html.Events exposing (onClick)

import Models exposing (..)
import Actions exposing (..)
import ViewUtils exposing (..)
import ModelUtils

view : CatalogData -> Int -> Html Msg
view catalog itemId =
  case ModelUtils.getSectionItem catalog itemId of
    Just (section, item) ->
      div []
        [ h2 []
            [ a [ href "#/", onClick ShowCatalog ] [ text "Home" ]
            , text " ⇢ "
            , a [ href ("#section/" ++ (toString section.id))
                , onClick (ShowSection section.id)
                ]
                [ text section.name ]
            ]
        , div [] [ text ("Show item: " ++ (toString itemId)) ]
        ]
    Nothing ->
      errorView ("Item " ++ (toString itemId) ++ " does not exist")
