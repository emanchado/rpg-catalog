port module Ports exposing (..)

import List
import Dict exposing (Dict)
import Json.Decode exposing (dict, list, index, andThen, string, int, succeed, fail)

import Models exposing (SearchIndex, CatalogResult(..))
import CatalogModels exposing (Catalog, CatalogSection, CatalogItem, SerializableCatalog)


catalogEntityIndex : Catalog -> (Dict Int CatalogSection, Dict Int CatalogItem)
catalogEntityIndex catalog =
  let
    allSections = catalog.sections

    sectionIndex =
      List.foldr
        (\section acc -> (section.id, section) :: acc)
        []
        allSections

    allItems = List.concat <|
                 List.map (\s -> s.items) allSections

    itemIndex =
      List.foldr
        (\item acc -> (item.id, item) :: acc)
        []
        allItems
  in
    ( Dict.fromList sectionIndex
    , Dict.fromList itemIndex
    )


parseSearchIndex : Catalog -> Json.Decode.Decoder SearchIndex
parseSearchIndex catalog =
  let
    (sectionIndex, itemIndex) = catalogEntityIndex catalog
  in
    dict
      (list
         (index 0 string |>
            andThen
              (\a -> index 1 int |>
                 andThen
                   (\b -> succeed (a, b) |>
                      andThen
                        (\(typ, id) -> case typ of
                                         "section" ->
                                           case (Dict.get id sectionIndex) of
                                             Just section ->
                                               succeed <| ResultSection section
                                             Nothing ->
                                               fail <| "Cannot find section " ++ (toString id)
                                         "item" ->
                                           case (Dict.get id itemIndex) of
                                             Just item ->
                                               succeed <| ResultItem item
                                             Nothing ->
                                               fail <| "Cannot find item " ++ (toString id)
                                         _ ->
                                           fail <| "Invalid result type " ++ typ)))))


port indexCatalog : SerializableCatalog -> Cmd msg
port indexCatalogSuccess : (Json.Decode.Value -> msg) -> Sub msg
