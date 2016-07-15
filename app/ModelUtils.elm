module ModelUtils exposing (..)

import Set

import CatalogModels exposing (Catalog, CatalogSection, CatalogItem)

getSection : Catalog -> Int -> Maybe CatalogSection
getSection catalog sectionId =
  let
    matchingSections = List.filter (\s -> s.id == sectionId) catalog.sections
  in
    case List.head matchingSections of
      Just section ->
        Just section
      Nothing ->
        Nothing

getSectionTags : CatalogSection -> List String
getSectionTags section =
  Set.toList
    (List.foldl
       (\i tags -> Set.union tags (Set.fromList i.tags))
       Set.empty
       section.items)

getSectionItem : Catalog -> Int -> Maybe (CatalogSection, CatalogItem)
getSectionItem catalog itemId =
  List.foldl
    (\s res ->
       let
         foundItem = List.head (List.filter (\i -> i.id == itemId) s.items)
       in
         case foundItem of
           Just item ->
             Just (s, item)
           Nothing ->
             res)
    Nothing
    catalog.sections

relatedItems : Catalog -> CatalogItem -> List CatalogItem
relatedItems catalog item =
  let
    allItems =
      List.filter
        (\i -> i /= item)
        (List.concatMap (\s -> s.items) catalog.sections)

    referenceTagSet = Set.fromList item.tags

    scoredItems =
      List.map
        (\i ->
           let
             numberCommonTags =
               Set.size (Set.intersect
                           referenceTagSet
                           (Set.fromList i.tags))
           in
             (i, numberCommonTags))
        allItems

    relatedItems =
      List.filter
        (\i -> (snd i) > 0)
        scoredItems
  in
    List.map
      fst
      (List.sortBy (\i -> (snd i) * -1) relatedItems)
