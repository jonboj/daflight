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

import 'dart:async';

import 'package:mdcdalight/mdcdalight.dart';

import 'entry_page.dart';
import 'airport_list.dart';
import 'route_list.dart';
import 'signin_reg_page.dart';

const int WAIT_FILE_LOAD_MS = 10;

//If const used dart2js gives error changed to final, see https://github.com/dart-lang/sdk/issues/17207.
//Typemap used for minimized builds, where typenames also get minimized.
final Map<Type, String> TYPE_NAME_MAP = {MdcButtonDart: 'MdcButtonDart', MdcTextfieldDart: 'MdcTextfieldDart',
                                        MdcSnackbarDart: 'MdcSnackbarDart', MdcSimpleMenuDart: 'MdcSimpleMenuDart',
                                        MdcTemporaryDrawerDart: 'MdcTemporaryDrawerDart', MdcdaListSelect: 'MdcdaListSelect',
                                        MdcdaPages: 'MdcdaPages', MdcdaIconButton: 'MdcdaIconButton', AirportList: 'AirportList',
                                        RouteList: 'RouteList', SigninRegPage: 'SigninRegPage', EntryPage: 'EntryPage'};

final List<ElementTagBundle> ELEM_BUNDLE_LIST = [MdcButtonDart.tagBundle, MdcTextfieldDart.tagBundle, MdcSnackbarDart.tagBundle,
  MdcSimpleMenuDart.tagBundle, MdcTemporaryDrawerDart.tagBundle, MdcdaListSelect.tagBundle,
  MdcdaPages.tagBundle, MdcdaIconButton.tagBundle, AirportList.tagBundle,
  RouteList.tagBundle, SigninRegPage.tagBundle, EntryPage.tagBundle];

main() async {
  print('======= Start of init MyFlight =======');
  //Load css files not loaded in corresponding _js.html file.
  MdcCSSLoader.loadCss(MdcComp.BASE_COMP);

  CustomElementReg.initWithDump(TYPE_NAME_MAP);

  //Pause to allow the loading of mdc js files, before mdcda components are registered. If a load complete event could
  //be identified for triggering of components register then a better solution. Anyhow 10ms will in any case be less
  //than actual load time of mdc js files.
  await new Future.delayed(const Duration(milliseconds: WAIT_FILE_LOAD_MS), () =>
     //Register all elements.
    ELEM_BUNDLE_LIST.forEach((final ElementTagBundle eBundle){HtmlImportManager.registerBundleElement(eBundle);})
  );

  //print('Elements registered dump typename map : ' + CustomElementReg.dumpToDartMap());

  print('======= End of init MyFlight =======');
}
