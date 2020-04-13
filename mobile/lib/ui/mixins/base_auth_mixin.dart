import 'dart:async';

import 'package:bittrex_app/i18n/i18n.dart';
import 'package:core/repositories/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

abstract class BaseAuthMixin {
  BuildContext get buildContext;
  AccountStore get accountStore;
  AccountRepository get accountRepository =>
      kiwi.Container().resolve<AccountRepository>();

  // Return true if should create new account, return false to abort
  Future<bool> shouldContinueAfterCheckingExistingAccount(
    String email,
    IdentityProvider provider,
  ) async {
    if (email == null || email.length == 0) {
      return true; // continue
    }
    final providers = await accountRepository.existingIdentityProviders(email);

    if (providers.length == 0 || providers.contains(provider)) {
      return true; // continue
    } else {
      // Account exists with a different provider, ask user the options
      return await showExistingAccountDialog();
    }
  }

  Future<bool> showExistingAccountDialog() {
    final completer = Completer();
    AlertUtils.show(
        context: buildContext,
        title: I18n.of(buildContext).text('dialog_login_account_exists_title'),
        message:
            I18n.of(buildContext).text('dialog_login_account_exists_message'),
        defaultButtonTitle: I18n.of(buildContext)
            .text('dialog_login_account_exists_create_new_button'),
        actionButtonTitle: I18n.of(buildContext)
            .text('dialog_login_account_exists_login_other_button'),
        actionCallback: () {
          completer.complete(false);
        },
        defaultCallback: () {
          completer.complete(true);
        });
    return completer.future;
  }
}
