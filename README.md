RPG Catalog
===========

This is an example catalog that uses the format produced by
[Cataloger](https://github.com/emanchado/cataloger). The "production"
copy is http://rpg.hcoder.org.

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

Dependencies
------------

This catalog is written in Elm, so you need to install it with:

    npm install -g elm

Then you'll need to install the Elm packages and the regular Node
packages with:

    elm-package install
    npm install

Using this Catalog
------------------

To use this catalog, you first need to generate a catalog JSON and
images using [Cataloger](https://github.com/emanchado/cataloger), and
copy all the files inside `app/assets/catalog/`.

Then, compile the Elm to the final JS with `npm run build`. At that
point you will have everything you need under `public/`. You can
either load `public/index.html` in a browser, or copy the whole
directory to a web server to be served statically.

Ideas for the future
--------------------

* Add tag cloud or similar to each section highlights, and/or for
  the whole catalog
* Add search box to search for stuff
* Make tags clickable and show items, regardless of section, that are
  tagged with that

Credits
-------

* Pin icon by
  [Madebyoliver](http://www.flaticon.com/authors/madebyoliver) from
  [Flaticon](http://www.flaticon.com), licensed by
  [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/)
* Pretty much the rest by Esteban Manchado Velázquez
