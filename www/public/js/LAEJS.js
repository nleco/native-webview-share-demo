(function () {
    window.LAEJS = {};

    var _isAndroid = (function () {
        if (window.JSI && typeof window.JSI === 'object') {
            //JSI.function(stuff);
            return true
        }

        return false;
    })();

    var _isIOS = (function () {
        if (window.webkit && window.webkit.messageHandlers && typeof window.webkit.messageHandlers === 'object') {
            //w.webkit.messageHandlers.jsHandler.postMessage(text);
            return true;
        }

        return false;
    })();

    LAEJS.dispatch = {
        shareURL : function (params) {
            var _defaults = {
                title : null,
                text : null,
                url: null,
                img: null,
                cb : null
            };

            var config = Object.assign({}, _defaults, params);
            var json = JSON.stringify(config);
            debug('sharing');
            if (_isAndroid) {
                debug('android')
                window.JSI.share(config.title, config.text, config.url);
            } else if (_isIOS) {
                debug('ios');
                window.webkit.messageHandlers.share.postMessage(json);
            }
        }
    };
})();