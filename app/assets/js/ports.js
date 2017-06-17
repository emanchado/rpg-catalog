/*global app, Worker */

// Start the indexing web worker
var worker = new Worker("js/indexing-worker.js");

app.ports.indexCatalog.subscribe(function(catalog) {
    worker.addEventListener("message", function(evt) {
        app.ports.indexCatalogSuccess.send(evt.data);
    });

    worker.postMessage(catalog);
});
