// Copied from Dataprovider 20-04-16

if (typeof module != 'undefined' && module.exports){
	WinJS = require("node-winjs");
    XMLHttpRequest = require('w3c-xmlhttprequest').XMLHttpRequest;


    (function xhrInit(){
        //Shim in WinJS xhr function
        WinJS.xhr = function (options) {
            /// <signature helpKeyword="WinJS.xhr">
            /// <summary locid="WinJS.xhr">
            /// Wraps calls to XMLHttpRequest in a promise.
            /// </summary>
            /// <param name="options" type="Object" locid="WinJS.xhr_p:options">
            /// The options that are applied to the XMLHttpRequest object. They are: type,
            /// url, user, password, headers, responseType, data, and customRequestInitializer.
            /// </param>
            /// <returns type="WinJS.Promise" locid="WinJS.xhr_returnValue">
            /// A promise that returns the XMLHttpRequest object when it completes.
            /// </returns>
            /// </signature>
            var req;
            return new WinJS.Promise(
                function (c, e, p) {
                    /// <returns value="c(new XMLHttpRequest())" locid="WinJS.xhr.constructor._returnValue" />
                    req = new XMLHttpRequest();
                    req.onreadystatechange = function () {
                        if (req._canceled) { return; }

                        if (req.readyState === 4) {
                            if (req.status >= 200 && req.status < 300) {
                                c(req);
                            } else {
                                e(req);
                            }
                            req.onreadystatechange = function () { };
                        } else {
                            p(req);
                        }
                    };

                    req.open(
                        options.type || "GET",
                        options.url,
                        // Promise based XHR does not support sync.
                        //
                        true,
                        options.user,
                        options.password
                    );
                    req.responseType = options.responseType || "";

                    Object.keys(options.headers || {}).forEach(function (k) {
                        req.setRequestHeader(k, options.headers[k]);
                    });

                    if (options.customRequestInitializer) {
                        options.customRequestInitializer(req);
                    }

                    req.send(options.data);
                },
                function () {
                    req._canceled = true;
                    req.abort();
                }
            );
        };
    })();
}

(function dataModelInit() {
    "use strict";

    WinJS.Namespace.define("XboxJS.Data", {
        /// <summary locid="XboxJS.Data.DataModel">
        /// A class to represent a service data model.
        /// </summary>
        /// <resource type="javascript" src="//Microsoft.WinJS.1.0/js/base.js" shared="true" />
        DataModel: WinJS.Namespace._lazy(function () {
            return WinJS.Class.define(null, {
                initialize: function (item) {
                    /// <signature helpKeyword="XboxJS.Data.DataModel.initialize">
                    /// <summary locid="XboxJS.Data.DataModel.initialize">
                    /// Finds all methods on the class, calls them, and stores their result in a property
                    /// with the same name.
                    /// </summary>
                    /// </signature>
                    var modelInstance = this;
                    var model = Object.getPrototypeOf(modelInstance);
                    var promises = [];

                    //Once we have an instance, calling initialize again doesn't make sense
                    delete modelInstance.initialize;

                    //Skip the constructor and initialize methods
                    for (var func in model) {
                        if (typeof (modelInstance[func]) === "function" &&
                            func !== "initialize" && func !== "constructor" && !{}.hasOwnProperty(func)) {
                            //call it
                            var result = modelInstance[func](item);

                            //add the promise to the list, then cache the result in the object
                            if (result && result.then) {
                                promises.push(modelInstance._setProperty(func, result));
                                //no promise returned, just store teh result in the object
                            } else {
                                modelInstance[func] = result;
                            }
                        }
                    }

                    //wait for all the promises to finish. We complete on the instance to allow datamodel chaining
                    return WinJS.Promise.join(promises).then(function () {
                        return WinJS.Promise.wrap(modelInstance);
                    });
                },
                _setProperty: function (func, promise) {
                    var that = this;
                    return promise.then(function (result) {
                        that[func] = result;
                    });
                }
            });
        })
    });
})();


(function dataProviderInit() {
    "use strict";

/*    WinJS.Namespace.define("XboxJS.Data.ContentType", {
        /// <field type="String" locid="XboxJS.Data.ContentType.album" helpKeyword="XboxJS.Data.ContentType.album">
        /// Album content type.
        /// </field>
        album: "album",

        /// <field type="String" locid="XboxJS.Data.ContentType.movie" helpKeyword="XboxJS.Data.ContentType.movie">
        /// Movie content type.
        /// </field>
        movie: "movie",

        /// <field type="String" locid="XboxJS.Data.ContentType.musicArtist" helpKeyword="XboxJS.Data.ContentType.musicArtist">
        /// Movie content type.
        /// </field>
        musicArtist: "musicArtist",

        /// <field type="String" locid="XboxJS.Data.ContentType.track" helpKeyword="XboxJS.Data.ContentType.track">
        /// Track content type.
        /// </field>
        track: "track",

        /// <field type="String" locid="XboxJS.Data.ContentType.tvShow" helpKeyword="XboxJS.Data.ContentType.tvShow">
        /// TV Show content type.
        /// </field>
        tvShow: "tvShow",

        /// <field type="String" locid="XboxJS.Data.ContentType.tvEpisode" helpKeyword="XboxJS.Data.ContentType.tvEpisode">
        /// TV Episode content type.
        /// </field>
        tvEpisode: "tvEpisode",

        /// <field type="String" locid="XboxJS.Data.ContentType.tvSeries" helpKeyword="XboxJS.Data.ContentType.tvSeries">
        /// TV Series content type.
        /// </field>
        tvSeries: "tvSeries",

        /// <field type="String" locid="XboxJS.Data.ContentType.tvSeason" helpKeyword="XboxJS.Data.ContentType.tvSeason">
        /// TV Season content type.
        /// </field>
        tvSeason: "tvSeason",

        /// <field type="String" locid="XboxJS.Data.ContentType.webVideo" helpKeyword="XboxJS.Data.ContentType.webVideo">
        /// Short form web content or user generated video.
        /// </field>
        webVideo: "webVideo",

        /// <field type="String" locid="XboxJS.Data.ContentType.webVideoCollection" helpKeyword="XboxJS.Data.ContentType.webVideoCollection">
        /// A collection of web videos such as videos from a playlist or in a subscription.
        /// </field>
        webVideoCollection: "webVideoCollection"
    });*/

    WinJS.Namespace.define("XboxJS.Data", {
        /// <summary locid="XboxJS.Data.DataProvider">
        /// A class to represent a service data provider.
        /// </summary>
        /// <resource type="javascript" src="//Microsoft.WinJS.1.0/js/base.js" shared="true" />
        DataProvider: WinJS.Namespace._lazy(function () {
            return WinJS.Class.define(function () {
                /// <signature helpKeyword="XboxJS.Data.DataProvider">
                /// <summary locid="XboxJS.Data.DataProvider.constructor">
                /// Creates a new DataProvider instance
                /// </summary>
                /// <returns type="XboxJS.Data.DataProvider" locid="XboxJS.Data.DataProvider.constructor_returnValue">
                /// The new DataProvider
                /// </returns>
                /// </signature>
                this._baseDataProviderConstructor();
            }, {
                // returns a function that wraps the function on the child data provider
                // in order to wrap the results in the appropriate dataModel, and provide caching
                _generateDataMethod: function (providerInstance, DataModel, innerMethod) {
                    var that = this;
                    return function wrappedDataMethod() {
                        var outerMethod = wrappedDataMethod;

                        // we have some cached data, just return that
                        if (outerMethod.items && outerMethod.items.length > 0) {
                            return WinJS.Promise.wrap(outerMethod.items);
                        } else {
                            //call the sub method with the arguments we were called with
                            var result = innerMethod.apply(providerInstance, arguments);

                            if (result && result.then) {
                                return result.then(function (result) {
                                    if (result) {
                                        return that._wrapData(result, DataModel, outerMethod);
                                    }
                                    else {
                                        // if we got no results, return an empty array
                                        return WinJS.Promise.wrap([]);
                                    }
                                });
                            } else {
                                if (result) {
                                    return that._wrapData(result, DataModel, outerMethod);
                                }
                                else {
                                    // if we got no results, return an empty array
                                    return WinJS.Promise.wrap([]);
                                }
                            }
                        }
                    };
                },
                _initializeData: function (item, resultData) {
                    return item.initialize(resultData);
                },
                _wrapData: function (result, DataModel, method) {
                    var that = this;
                    var data = [];
                    var promises = [];

                    // for each item, wrap it in the correct dataModel, and cache the result
                    for (var i = 0; i < result.length; i++) {
                        //if this is a real item
                        if (result[i]) {
                            var item = new DataModel();
                            item.index = item.index || i;
                            data.push(item);
                            promises.push(that._initializeData(item, result[i]));
                        }
                    }

                    // when done, return all the dataModel objects
                    return WinJS.Promise.join(promises).then(function () {
                        return new WinJS.Promise(function (complete, err) {
                            // if the inner method has requested that we don't cache its data, then don't
                            if (method.items) {
                                method.items = data;
                            }
                            complete(data);
                        });
                    });
                },
                // find all the dataProvider objects, and wrap their methods in methods of the same name
                _baseDataProviderConstructor: function () {
                    var providerInstance = this;
                    var provider = Object.getPrototypeOf(providerInstance);
                    var rootDataModel = null;

                    for (var prop in provider) {
                        // do we have a root level data model
                        if (provider.hasOwnProperty(prop) && prop === "DataModel") {
                            rootDataModel = provider[prop];
                            // we have a root level data model, so we need to wrap root level methods
                        } else if (provider.hasOwnProperty(prop) && rootDataModel &&
                            typeof providerInstance[prop] === "function") {
                            providerInstance[prop] = this._generateDataMethod(providerInstance, rootDataModel, providerInstance[prop]);
                            providerInstance[prop].items = [];
                            //inner object
                        } else if (provider.hasOwnProperty(prop) && typeof (providerInstance[prop]) === "object") {
                            // if this object has a datamodel property, we have a dataModel object to process
                            if (provider[prop].hasOwnProperty("DataModel")) {
                                // override the property on the instance so we don't step over the parent property
                                providerInstance[prop] = {};

                                for (var func in provider[prop]) {
                                    // if this property is a function
                                    if (provider[prop].hasOwnProperty(func) && typeof (provider[prop][func]) === "function" && func !== "DataModel") {
                                        // generate a new wrapped method, and initialize the cache
                                        providerInstance[prop][func] = this._generateDataMethod(providerInstance, provider[prop].DataModel, provider[prop][func]);
                                        providerInstance[prop][func].items = [];
                                    }
                                }
                            }
                        }
                    }
                }
            });
        })
    });
})();