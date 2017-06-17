module SearchResultsView exposing (..)

import Html exposing (Html, h1, h2, nav, aside, div, span, ul, li, a, input, text, img)
import Html.Attributes exposing (class, title)
import Html.Events exposing (onClick)
import Dict exposing (Dict)

import CatalogModels exposing (CatalogSection, CatalogItem)
import Models exposing (Model, SearchIndex, CatalogResult(..))
import Messages exposing (Msg(..))
import ViewUtils exposing (coverImage)


sectionSearchResultView : CatalogSection -> Html Msg
sectionSearchResultView section =
  div [ class "search-result"
      , onClick (ShowSection section.id)
      ]
    [ coverImage section "64x64" "/images/default-section.png"
    , div [ class "result-text" ]
        [ div [ class "result-title" ]
            [ text <| "Section: " ++ section.name ]
        , div [ class "result-description" ] [ text section.description ]
        ]
    ]

itemSearchResultView : CatalogItem -> Html Msg
itemSearchResultView item =
  div [ class "search-result"
      , onClick (ShowItem item.id)
      ]
    [ coverImage item "64x64" "/images/default-item.png"
    , div [ class "result-text" ]
        [ div [ class "result-title" ]
            [ text item.name ]
        , div [ class "result-description" ] [ text item.description ]
        ]
    ]


searchResultsView : SearchIndex -> String -> List (Html Msg)
searchResultsView searchIndex searchTerms =
  case (Dict.get searchTerms searchIndex) of
    Just results -> List.map
                      (\result -> case result of
                                    ResultSection section ->
                                      li []
                                        [ sectionSearchResultView section ]
                                    ResultItem item ->
                                      li []
                                        [ itemSearchResultView item ])
                      results
    Nothing -> []


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text <| "Search term was: " ++ model.searchTerms ]
    , ul [ class "search-results" ]
        (case model.searchIndex of
           Just searchIndex ->
             searchResultsView searchIndex <| String.toLower model.searchTerms
           Nothing ->
             [ text "No search index" ])
    ]
