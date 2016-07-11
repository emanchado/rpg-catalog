module ModelUtils exposing (..)

import Set

import Models exposing (..)

getSection : CatalogData -> Int -> Maybe CatalogSection
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
