module ItemDetailView exposing (view)

import Html exposing (Html, h1, h2, nav, aside, div, span, ul, li, a, input, text, img)
import Html.Attributes exposing (class, src, href)
import Html.Events exposing (onClick)
import Markdown

import Models exposing (..)
import Actions exposing (..)
import ViewUtils exposing (..)
import ModelUtils
import CatalogModels exposing (..)

tagView : String -> Html Msg
tagView tag =
  li []
    [ a [ class "tag" ] [ text tag ]
    ]

itemView : Catalog -> CatalogItem -> Html Msg
itemView catalog item =
  div [ class "item-card" ]
    [ aside [ class "tag-sidebar" ]
      [ h2 [] [ text "Tags" ]
      , ul []
          (List.map tagView item.tags)
      ]
    , div [ class "item-main-content" ]
      [ div [ class "item-main-image" ]
          [ coverImage item "300x300" "/images/default-item.png"
          ]
      , h1 [] [ text item.name ]
      , Markdown.toHtml [] item.description
      ]
    , div [ class "related-items" ]
      [ h2 [] [ text "Related items" ]
      , ul [ class "item-list" ]
          (List.map
             (ViewUtils.smallItemView "" (\id -> ShowItem id))
             (ModelUtils.relatedItems catalog item))
      ]
    ]

view : Catalog -> Int -> Html Msg
view catalog itemId =
  case ModelUtils.getSectionItem catalog itemId of
    Just (section, item) ->
      div []
        [ nav []
            [ a [ href "#/", onClick ShowCatalog ] [ text "Home" ]
            , text " ⇢ "
            , a [ href ("#section/" ++ (toString section.id))
                , onClick (ShowSection section.id)
                ]
                [ text section.name ]
            , text " ⇢ "
            , text item.name
            ]
        , itemView catalog item
        ]
    Nothing ->
      errorView ("Item " ++ (toString itemId) ++ " does not exist")
