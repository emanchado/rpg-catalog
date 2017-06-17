module CatalogModels exposing (..)

import Dict

type alias CatalogSectionId = Int
type alias CatalogItemId = Int


type alias SerializableCatalogItem =
  { id : CatalogItemId
  , name : String
  , description : String
  , tags : List String
  }

type alias SerializableCatalogSection =
  { id : CatalogSectionId
  , name : String
  , description : String
  , items : List SerializableCatalogItem
  }

type alias SerializableCatalog =
  { name : String
  , sections : List SerializableCatalogSection
  }

type alias CoverImage = Maybe (Dict.Dict String String)

type alias CatalogItem =
  { id : CatalogItemId
  , name : String
  , description : String
  , tags : List String
  , url : Maybe String
  , coverImage : CoverImage
  }

type alias CatalogSection =
  { id : CatalogSectionId
  , name : String
  , description : String
  , items : List CatalogItem
  , coverImage : CoverImage
  }

type alias Catalog =
  { name : String
  , thumbnailSizes : List String
  , sections : List CatalogSection
  }


serializableCatalog : Catalog -> SerializableCatalog
serializableCatalog catalog =
  { name = catalog.name
  , sections = List.map
                 (\s -> { id = s.id
                        , name = s.name
                        , description = s.description
                        , items = List.map
                                    (\i -> { id = i.id
                                           , name = i.name
                                           , description = i.description
                                           , tags = i.tags
                                           })
                                    s.items
                        })
                 catalog.sections
  }
