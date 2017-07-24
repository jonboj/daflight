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

import 'package:mdcdalight/mdcdalight.dart';

import 'customelem_html_path.dart';

class AirportData {
  final String iata;
  final String name;
  final String country;
  final double long;
  final double lat;
  const AirportData(final String this.iata, final String this.name, final String this.country,
                    final double this.lat, final double this.long);
}

class AirportDataWrap extends AirportData implements IListItemBind {
  static const String IATA = 'iata';
  static const String NAME = 'name';
  static const String COUNTRY = 'country';

  const AirportDataWrap(final String iata, final String name, final String country,
                        final double lat, final double long)
      : super( iata, name, country, lat, long);

  Map<String, PropertyBind> bindListAt() =>
      buildAccessMap([bindAtFactory(IATA, iata), bindAtFactory(NAME, name),
                      bindAtFactory(COUNTRY, country)]);
}

class AirportListPropBind implements IPropBind {
  List<AirportDataWrap> airportList =
     [const AirportDataWrap('PEK', 'Beijing Capital International Airport', 'China', 40.072444, 116.597497),
      const AirportDataWrap('AMS', 'Amsterdam Schiphol Airport', 'Netherlands', 52.308613, 4.763889),
      const AirportDataWrap('SVO', 'Sheremetyevo International Airport', 'Russian Federation', 55.972642, 37.414589),
      const AirportDataWrap('GRU', 'São Paulo-Guarulhos International Airport', 'Brazil', -23.432075, -46.469511),
      const AirportDataWrap('LAX', 'Los Angeles International Airport', 'United States', 33.942495, -118.408068),
      const AirportDataWrap('JFK', 'John F Kennedy International Airport', 'United States', 40.639751, -73.778926)];

  //// Binding instrumentation section ////
  static const String AIRPORT_LIST = 'airportList';

  static const Map<String, int> _propNameMap = const {AIRPORT_LIST : 0};
  static final List<String> _attrKeys = attrKeyFromProp(_propNameMap);

  Map<String, int> get propNameIndex => _propNameMap;
  List<String> get attrKeys => _attrKeys;
  List<PropertyBindSet> get bindProp =>
      [new PropertyBindSet(AIRPORT_LIST, () => airportList, (final List<AirportDataWrap> l){airportList = l;})];
}

class AirportList extends HtmlElement with AirportListPropBind, BindBaseCtrl implements ICustomBindElement {

  static final TagBundleCustomDart tagBundle = new TagBundleCustomDart(CUSTOM_ELEM_PATH, AirportList);

  static void registerElement(){
    HtmlImportManager.registerBundleElement(tagBundle);
  }

  AirportList.created(): super.created(){
    print('AirportList.created()');
    final Node n = HtmlImportManager.nodeFromTemplate(tagBundle);
    print('AirportList.HtmlImportManager.nodeFromTemplate');
    this.append(n);
    createBindFromElement(this);
  }

  void attached(){
    print('AirportList.attached()');
    List<MdcdaListSelect> listSelect = MdcdaListSelect.childMdcdaListSelect(this);
    listSelect.forEach((final MdcdaListSelect repElem){
      repElem.fillList();
    });
  }

}
