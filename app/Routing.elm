module Routing exposing (..)

import Navigation
import UrlParser exposing (..)


type Route
  = CatalogIndex
  | SectionIndex Int
  | ItemDetail Int
  | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ map CatalogIndex (s "")
    , map SectionIndex (s "section" </> int)
    , map ItemDetail (s "item" </> int)
    ]


parseLocation : Navigation.Location -> Route
parseLocation location =
  let
    fixedLocation = if location.hash == "" then
                      { location | hash = "#/" }
                    else
                      location
  in
    case (parseHash matchers fixedLocation) of
      Just route -> route
      Nothing -> NotFoundRoute


routeFromResult : Result String Route -> Route
routeFromResult result =
  case result of
    Ok route ->
      route
    Err string ->
      NotFoundRoute
