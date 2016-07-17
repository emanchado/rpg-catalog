module CatalogModels exposing (..)

import Dict

type alias CatalogSectionId = Int
type alias CatalogItemId = Int

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
