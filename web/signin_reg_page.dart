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

import 'app_data.dart';
import 'customelem_html_path.dart';

class SignInEvent extends MdcdaEvent {
  static const String LOC_TYPE = 'myflight-signin';
  final String name;
  //SelectChangeEvent with argument in constructor is used to obtain from class.
  const SignInEvent()
      : name = null, super(LOC_TYPE);

  SignInEvent.fromName(final String this.name)
      : super(LOC_TYPE);
}

class SigninRegPage extends HtmlElement with ListenerAttrBinding {

  static const String FIRST_NAME_ID = 'firstname';
  static const String LAST_NAME_ID = 'lastname';
  static const String EMAIL_ID = 'email';
  static const String PASSW_ID = 'password';

  static const String REGISTER_PROP = 'registerprop';

  static final TagBundleCustomDart tagBundle = new TagBundleCustomDart(CUSTOM_ELEM_PATH, SigninRegPage);

  static void registerElement() {
    HtmlImportManager.registerBundleElement(tagBundle);
  }

  SigninRegPage.created() : super.created(){
    print('SigninRegPage.created()');
    final Node n = HtmlImportManager.nodeFromTemplate(tagBundle);
    this.append(n);

    listenerHandlers = {'showRegisterForm' : this.showRegisterForm,
                         'readRegisterForm' : this.readRegisterForm,
                         'signIn' : this.signIn};
    registerAttributeEventHandlers(this, AttrEventType.EVENT_LIST);
  }

  void showRegisterForm(Event e){
    print('SigninRegPage.showRegisterForm');
    attributes[REGISTER_PROP] = '';
  }

  void readRegisterForm(Event e){
    print('SigninRegPage.readRegisterForm');

    AccountData account = new AccountData(_valueFromId(FIRST_NAME_ID), _valueFromId(LAST_NAME_ID),
                                          _valueFromId(EMAIL_ID), _valueFromId(PASSW_ID));

    AppData.addNewAccount(account);
    AppData.signIn(account.email, account.password);

    //Show signin
    attributes.remove(REGISTER_PROP);
  }

  void signIn(Event e) {
    print('SigninRegPage.signIn');
    AppData.signIn(_valueFromId(EMAIL_ID), _valueFromId(PASSW_ID));
    MdcdaEventUtil.dispatch(this, new SignInEvent.fromName(AppData.activeUser.firstName));
  }

  //picks values from input element.
  String _valueFromId(final String id){
    final InputElement e = this.querySelector('#' + id) as InputElement;
    return e.value;
  }

}