// Copyright 2017 Jonas Bojesen. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:html';

import 'package:google_maps/google_maps.dart' as gmap;

import 'package:mdcdalight/mdcdalight.dart';

import 'airport_list.dart';
import 'route_list.dart';
import 'signin_reg_page.dart';
import 'customelem_html_path.dart';

abstract class EntryPagePropBind implements IPropBind {

  int selectedPage = 0;
  String signinName = '';

  //// Binding instrumentation section ////
  static const String SELECTED_PAGE = 'selectedPage';
  static const String SIGNIN_NAME = 'signinName';
  static const Map<String, int> _propNameMap = const {SELECTED_PAGE : 0, SIGNIN_NAME : 1};
  static final List<String> _attrKeys = attrKeyFromProp(_propNameMap);

  Map<String, int> get propNameIndex => _propNameMap;
  List<String> get attrKeys => _attrKeys;
  List<PropertyBindSet> get bindProp =>
      [new PropertyBindSet(SELECTED_PAGE, () => selectedPage, (final int i){selectedPage = i;}),
       new PropertyBindSet(SIGNIN_NAME, () => signinName, (final String s){signinName = s;})];
}

class EntryPage extends HtmlElement with EntryPagePropBind, BindBaseCtrl, ListenerAttrBinding
                                    implements ICustomBindElement {

  static const String SIGNIN_ATTRIBUTE = 'signinprop';
  static final TagBundleCustomDart tagBundle = new TagBundleCustomDart(CUSTOM_ELEM_PATH, EntryPage);

  static void registerElement() {
    HtmlImportManager.registerBundleElement(tagBundle);
  }

  gmap.GMap _routeMap;
  Element _mapContianer;
  RouteList _routeList;
  MdcTemporaryDrawerDart _drawer;
  MdcSimpleMenuDart _drawerMenu;
  MdcSnackbarDart _snackbar;

  EntryPage.created() : super.created(){
    print('EntryPage.created()');
    final Node n = HtmlImportManager.nodeFromTemplate(tagBundle);
    this.append(n);
    createBindFromElement(this);
    registerPropNotification(EntryPagePropBind.SELECTED_PAGE, handleSelectedPageUpdate);
  }

  void attached() {
    registerListener();
    _routeList =  this.querySelector('route-list') as RouteList;

    _drawer = this.querySelector('#id_drawer');
    _drawerMenu = this.querySelector('#id_drawer_menu');
    _snackbar = document.querySelector('mdc-snackbar-dart') as MdcSnackbarDart;
    _mapContianer = this.querySelector('#id-route-map');
  }

  void registerListener() {
    listenerHandlers =
       {'toggleDrawer': this.toggleDrawer,
        'selectAirportList': MdcdaEventUtil.wrapMdcdaHandler(this.selectAirportList),
        'selectRouteHandler': MdcdaEventUtil.wrapMdcdaHandler(this.selectRouteHandler),
        'signInHandler' : MdcdaEventUtil.wrapMdcdaHandler(this.signInHandler)};

    List<String> eventTypes = new List<String>.from(AttrEventType.EVENT_LIST);
    eventTypes.add(const SelectChangeEvent().type);
    registerAttributeEventHandlers(this, eventTypes);

    MdcdaEventUtil.registerHandler(this, const SignInEvent().type, signInHandler);
  }

  void selectAirportList(final MdcdaEvent e){
    print('EntryPage.selectAirportList - event type : ' + e.type);
    final SelectChangeEvent selectEvent = e as SelectChangeEvent;
    print('EntryPage.selectAirportList - selected : ' + selectEvent.index.toString());

    AirportList airportl = this.querySelector('airport-list') as AirportList;
    AirportData ap = airportl.airportList[selectEvent.index];
    _routeList.addAirPort(ap);

    _snackbar.show('Added to route ' + ap.iata + ', ' + ap.name);
  }

  //Not real action, just log
  void selectRouteHandler(final MdcdaEvent e){
    print('EntryPage.selectRouteHandler - event type : ' + e.type);
    print('EntryPage.selectRouteHandler - selected : ' + (e as SelectChangeEvent).index.toString());
  }

  void toggleDrawer(Event e){
    print('EntryPage.toggleDrawer');

    //On mobile when drawer closed with slide the menu state get out of sync.
    //Small fix by synch of states.
    if (_drawerMenu.open){
      _drawerMenu.open = false;
    }
    _drawer.open = !_drawer.open;
    _drawerMenu.open = _drawer.open;
  }

  void closeDrawer(){
    print('EntryPage.closeDrawer');
    _drawerMenu.open = false;
    _drawer.open = false;
  }

  void handleSelectedPageUpdate() {
    const int ROUTE_MAP_SELECT = 2;
    const int LOGOUT_SELECT = 3;

    //Notify the binding.
    updateProps([EntryPagePropBind.SELECTED_PAGE]);

    print('EntryPage.handleSelectedPageUpdate new value : ' + selectedPage.toString());
    MdcdaPages mdcdaPages = querySelector('#id_content_pages');
    mdcdaPages.selectPage();

    closeDrawer();//Close at selection, mobile app style.

    if (selectedPage == ROUTE_MAP_SELECT) {
      drawRouteMap();
    }

    if (selectedPage == LOGOUT_SELECT && attributes.containsKey(SIGNIN_ATTRIBUTE)) {
      //Do logout
      _signIn(false);
      attributes.remove(SIGNIN_ATTRIBUTE);
    }
  }

  void signInHandler(MdcdaEvent e){
    //pick name from event.
    signinName = (e as SignInEvent).name;
    print('EntryPage.signInHandler name : '  + signinName);
    _signIn(true);
    updateProps([EntryPagePropBind.SIGNIN_NAME]);
  }

  void drawRouteMap(){

    print('drawRouteMap : ' + this.style.cssText.toString());
    final gmap.MapOptions mapOptions = new gmap.MapOptions();
    _routeMap = new gmap.GMap(_mapContianer, mapOptions);

    gmap.LatLngBounds latlngbounds = new gmap.LatLngBounds();
    _buildPositions().forEach((final gmap.LatLng pos){latlngbounds.extend(pos);});
    _routeMap.fitBounds(latlngbounds);

    _routeList.airportList.forEach((final AirportDataWrap ap){
      new gmap.Marker(new gmap.MarkerOptions()
        ..position = new gmap.LatLng(ap.lat, ap.long)
        ..map = _routeMap
        ..label = new gmap.MarkerLabel().text = ap.iata);
    });

    new gmap.Polyline(new gmap.PolylineOptions()
      ..path = _buildPositions()
      ..geodesic = true
      ..strokeColor = '#FF0000'
      ..strokeOpacity = 1.0
      ..strokeWeight = 2
      ..map = _routeMap
    );
  }

  List<gmap.LatLng> _buildPositions(){
    return _routeList.airportList
        .map((final AirportDataWrap ap) => new gmap.LatLng(ap.lat, ap.long)).toList();
  }

  void _signIn(final bool signIn){

    if (signIn){
      attributes[SIGNIN_ATTRIBUTE] = '';
      _snackbar.show(signinName + ' signedin');
    }
    else {
      attributes.remove(SIGNIN_ATTRIBUTE);
      _snackbar.show(signinName + ' signedout');
    }
  }

}