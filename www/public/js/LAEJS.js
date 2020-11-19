(function (window) {
    var _isAndroid = window.JSI && typeof window.JSI === 'object';
    var _isIOS = window.webkit && window.webkit.messageHandlers && typeof window.webkit.messageHandlers === 'object';
    var _isNative = _isAndroid || _isIOS;
    var _isObject = function (obj) {
        return obj === Object(obj);
    };

    var debug = debug || console.log;

    var _ensureIsObject = function (objOrJSON) {
        var params = null;

        if (_isObject(objOrJSON)) {
            params = objOrJSON;
        } else if (typeof objOrJSON === 'string') {
            try {
                params = JSON.parse(objOrJSON);
            } catch (e) {
                throw "Invalid JSON passed in.";
            }
        }

        return params;
    };

    var _mergeWithDefaults = function (defaults, params) {
        var newParams = {};
        if (!_isObject(defaults)) {
            defaults = {};
        }

        if (!_isObject(params)) {
            params = {};
        }

        newParams = Object.assign({}, defaults, params)
    };

    var _isUrl = function (url) {
        var regex = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/;
        if (typeof url !== 'string') {
            return false;
        }

        return url.match(regex);
    }

    /**
     * General dispatch method to call iOS or Android native code.
     *
     * @param {string} method Name of the JS interface method.
     * @param {object|string} params key/value pair object, or JSON string, of data to send to the JS interface method.
     */
    var _dispatch = function (method, params) {
        var json = '{}';
        var mergedParams = {};
        var parsedParams = _ensureIsObject(params);
debug(method);
debug("------");
        if (typeof method !== 'string' || !method) {
            throw "name: is not a string";
        }

        if (_isObject(parsedParams)) {
            json = JSON.stringify(params);
        }

        if (_isAndroid && typeof window.JSI[method] === 'function') {
            (window.JSI[method])(json);
            return true;
        } else if (_isIOS && typeof window.webkitCancelAnimationFrame.messageHandlers[method] === 'function') {
            (window.webkit.messageHandlers[method]).postMessage(json);
            return true;
        }

        return false;
    };

    var _jsOnShare = function (params) {
        var text = params.text;
        var url = params.url;
        var title = params.title;

        if (typeof text !== 'string' || !text) {
            throw "text: Is not a string";
        }

        if (!_isUrl(url) || !url) {
            throw "url: Is not a valid URL.";
        }

        if (title && typeof title !== 'string') {
            throw "title: Is not a string.";
        }

        return _dispatch('jsOnShare', {
            text : text,
            url : url,
            title : title || null
        });
    };

    var _jsOnBackPressed = function () {
        return _dispatch('jsOnBackPressed', null);
    };

    var _jsOnLogout = function () {
        return _dispatch('jsOnLogout', null);
    };


    var _jsHandler = function (message) {
        return _dispatch('jsHandler', { message : message });
    }

    window.LAEJS = {
        dispatch : _dispatch,

        jsOnShare : _jsOnShare,
        jsOnBackPressed : _jsOnBackPressed,
        jsOnLogout : _jsOnLogout,
        jsHandler : _jsHandler
    };

})(window);