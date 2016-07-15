RPG Catalog
===========

This is an example catalog that uses the format produced by
[Cataloger](https://github.com/emanchado/cataloger).

In short, the idea of having a simple tool to make a static,
catalog-like websites. Cataloger would maintain the database with the
content and export it to JSON, and another program (a client, if you
will) would read that static JSON file and present the catalog.

This repo is an example of a catalog client: it reads a JSON file that
describes the items in the catalog and shows it, allowing the user to
browse the categories, filter by tags, see similar items to the
selected one, etc.

I wrote this partly as an experiment, to learn
[Elm](http://elm-lang.org/). Don't expect anything super advanced, and
don't expect I'll be constantly improving or expanding this.

TODO
====

* Improve tag highlighting style in section index page
* Add tag cloud or similar to each section highlights, and/or for
  the whole catalog
* Add search box to search for stuff
* Make tags clickable and show items, regardless of section, that are
  tagged with that
* Investigate the HTML5 history stuff, because pressing Back goes to a
  seemingly random place :-?
