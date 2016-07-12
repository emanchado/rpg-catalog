module Models exposing (..)

import Dict

import Routing

type alias CoverImage = Maybe (Dict.Dict String String)

type alias CatalogItem =
  { id : Int
  , name : String
  , description : String
  , tags : List String
  , url : Maybe String
  , coverImage : CoverImage
  }

type alias CatalogSection =
  { id : Int
  , name : String
  , items : List CatalogItem
  , coverImage : CoverImage
  }

type alias CatalogData =
  { name : String
  , thumbnailSizes : List String
  , sections : List CatalogSection
  }

type alias InterfaceProperties =
  { highlightedTag : Maybe String
  }

type alias Model =
  { route : Routing.Route
  , catalogUrl : String
  , catalogData : Maybe CatalogData
  , uiState : InterfaceProperties
  }
