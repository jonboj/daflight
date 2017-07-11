# Daflight

Demo/tutorial dart app for use of [mdcdalight](https://github.com/jonboj/mdcdalight) lib. Customized for mobile in Progressive Web App style with a `manifest.json`. For browser support Daflight is supported by Chrome desktop/android, or other browsers with native support for web components v0 like other blink based browsers.

 Hosted build of Daflight : https://tid4sport.com/daflight/web

#### Usage
From the `Airport list` compose a route, by airport selection with tap. The route will be shown in list and on map.

Note: Daflight is a demo client with no server connection, hence account creation and login functionality only holds credentials for the session and will not store these between sessions.

#### Mobile usage

Daflight has mobile-theming with fullscreen and theme color. To test this, choose from the browser menu 'Add to Home screen' and start Daflight from the Home Screen icon. This will start the app in fullscreen mode and with theming color. 
 
#### Build and deploy

Refer in `pubspec.yaml` to either a local clone of [mdcdalight](https://github.com/jonboj/mdcdalight) with [path](https://www.dartlang.org/tools/pub/dependencies#path-packages) or direct to repo [git](https://www.dartlang.org/tools/pub/dependencies#git-packages).

From project root build with standard `>pub build`. Dartium works for development and debug.

#### Gmap api_key

Apps accessing to gmap requires authentication, see https://pub.dartlang.org/packages/google_maps. A free api_key can be generated and managed from https://developers.google.com   


#### Note

An intention with Daflight is a more juicy app than a standard Todo app. 
 
Bundling and minimization of `html`,`js` and `css` files aren't implemented yet, this impacts startup time. Still a loaded Daflight app with connection is considered to give an indication of the PWA experience, which could be obtained if bundling, minimization and service workers are implemented.


----
See [LICENSE](./LICENSE.md) and [CHANGELOG](./CHANGELOG.md). 
