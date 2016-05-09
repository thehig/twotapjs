# TwoTap Client
# Summary

This project takes in a twotap cart and processes the cart data into consumable datamodels for winJS.

## Dataproviders

### Sample
This dataprovider uses fixture files for its data, it does not make any xhr calls.

### Callbackcatcher
This dataprovider makes requests out to our callback catcher site. It uses a twotap cart id for use on the /search route. 

## Whitelist files

* [Sitemodel]
* [SelectOne]
* [Product]
* [FailedProduct]
* [Cart]


[Sitemodel]: <https://github.com/thehig/twotapjs/blob/models/meteor/src/models/SiteModel.js#L90>
[SelectOne]: <https://github.com/thehig/twotapjs/blob/models/meteor/src/models/SelectOneModel.js#L93>
[Product]: <https://github.com/thehig/twotapjs/blob/models/meteor/src/models/ProductModel.js#L217>
[FailedProduct]: <https://github.com/thehig/twotapjs/blob/models/meteor/src/models/ProductModel.js#L165>
[Cart]: <https://github.com/thehig/twotapjs/blob/models/meteor/src/models/CartModel.js#L47>