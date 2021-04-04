import 'dart:io';

import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail/imap/imap_search.dart';
import 'package:enough_mail/mime_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';





class Mailer {
  String userName = 'user.name';
  String password = 'password';
  String domain = 'domain.com';


  Mailer({@required this.userName, @required this.password,@required this.domain});


  /// High level mail API example
  Future<void> mailExample() async {
    final email = '$userName@$domain';
    print('discovering settings for  $email...');
    final config = await Discover.discover(email);
    if (config == null) {
      print('Unable to autodiscover settings for $email');
      return;
    }
    print('connecting to ${config.displayName}.');
    final account =
    MailAccount.fromDiscoveredSettings('my account', email, password, config);
    final mailClient = MailClient(account, isLogEnabled: true);
    try {
      await mailClient.connect();
      print('connected');
      final mailboxes =
      await mailClient.listMailboxesAsTree(createIntermediate: false);
      print(mailboxes);
      await mailClient.selectInbox();
      final searchResult = await mailClient.searchMessages(MailSearch("Bar Ilan",SearchQueryType.allTextHeaders));
      // the first page of search results is already pre-cached:
      for (final msg in searchResult.messages.elements) {
        var msg1 = await mailClient.fetchMessageContents(msg, markAsSeen: true);
        final attachments = msg1.findContentInfo(disposition: ContentDisposition.attachment);
        for (final attachment in attachments) {
          final attachmentMimePart = msg1.getPart(attachment.fetchId);
          print('test');
          // print(attachmentMimePart.decodeContentBinary().length);
          final File file = File.fromRawPath(attachmentMimePart.decodeContentBinary());
          Directory appDocDir= await getExternalStorageDirectory();
          final String path = appDocDir.path;
          print('path is'+path);
          final File newFile = await file.copy('$path/test.pdf');

        }
      }
      mailClient.eventBus.on<MailLoadEvent>().listen((event) {
        print('New message at ${DateTime.now()}:');
        printMessage(event.message);
      });
      await mailClient.startPolling();
    } on MailException catch (e) {
      print('High level API failed with $e');
    }
  }




  void printMessage(MimeMessage message) {
    print('from: ${message.from} with subject "${message.decodeSubject()}"');
    if (!message.isTextPlainMessage()) {
      print(' content-type: ${message.mediaType}');
    } else {
      final plainText = message.decodeTextPlainPart();
      if (plainText != null) {
        final lines = plainText.split('\r\n');
        for (final line in lines) {
          if (line.startsWith('>')) {
            // break when quoted text starts
            break;
          }
          print(line);
        }
      }
    }
  }
}