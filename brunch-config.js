module.exports = {
    paths: {
        public: 'public/'
    },

    files: {
        javascripts: {joinTo: 'app.js'}
    },

    plugins: {
        elmBrunch: {
            mainModules: ['app/catalog.elm'],
            makeParameters: ['--warn']
        }
    }
};
