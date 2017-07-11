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

class AccountData {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const AccountData(final String this.firstName, final String this.lastName,
      final String this.email, final String this.password);
}


class AppData {
  static List<AccountData> _accounts = new List<AccountData>();

  static AccountData activeUser;


  static void addNewAccount(final AccountData account) => _accounts.add(account);

  static bool signIn(final String email, final String password){
    activeUser = _accounts.firstWhere((final AccountData ac) => ac.email == email && ac.password == password);
    return activeUser != null;
  }
}