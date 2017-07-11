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

import 'airport_list.dart';
import 'customelem_html_path.dart';

class RouteList extends HtmlElement with AirportListPropBind, BindBaseCtrl implements ICustomBindElement {

  static final TagBundleCustomDart tagBundle = new TagBundleCustomDart(CUSTOM_ELEM_PATH, RouteList);

  static void registerElement(){
    HtmlImportManager.registerBundleElement(tagBundle);
  }

  RouteList.created(): super.created(){
    print('RouteList.created()');
    airportList = [];
    final Node n = HtmlImportManager.nodeFromTemplate(tagBundle);
    print('RouteList.HtmlImportManager.nodeFromTemplate');
    this.append(n);
    createBindFromElement(this);
  }

  void attached(){
    print('RouteList.attached()');
    List<MdcdaListSelect> listSelect = MdcdaListSelect.childMdcdaListSelect(this);
    listSelect.forEach((final MdcdaListSelect repElem){
      repElem.fillList();
    });
  }

  void addAirPort(final AirportDataWrap ap){
    print('RouteList.addAirPort : ' + ap.iata);
    airportList.add(ap);
    List<MdcdaListSelect> listSelect = MdcdaListSelect.childMdcdaListSelect(this);
    listSelect.forEach((final MdcdaListSelect repElem){
      repElem.fillList();
    });
  }

}
