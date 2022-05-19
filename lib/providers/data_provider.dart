import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataProvider extends ChangeNotifier {
  List<Contact> _contacts = [];
  List<SmsMessage> _messages = [];
  List<dynamic> _videos = [];

  List<Contact> get contacts => _contacts;
  List<SmsMessage> get messages => _messages;
  List<dynamic> get videos => _videos;

  Future<void> getContacts(BuildContext context) async {
    try {
      PermissionStatus permissionStatus = await _getContactPermission();
      if (permissionStatus == PermissionStatus.granted) {
        _contacts =
            (await ContactsService.getContacts(withThumbnails: false)).toList();
        notifyListeners();
      } else {
        notifyListeners();
        _handleInvalidPermissions(permissionStatus, context);
      }
    } catch (e) {
      notifyListeners();
      // print(e);
    }
  }

  Future<void> getMessages() async {
    try {
      var permission = await Permission.sms.status;
      if (permission.isGranted) {
        final SmsQuery _query = SmsQuery();
        final messages = await _query.querySms(
          kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
          // count: 30,
        );

        _messages = messages;
        notifyListeners();
      } else {
        notifyListeners();
        await Permission.sms.request();
      }
    } catch (e) {
      notifyListeners();
      // print(e);
    }
  }

  Future<void> getVideos() async {
    try {
      http.Response response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/youtube/v3/search?key=AIzaSyBXMmxLVIK1jm1j0my0W3ymwbJ9RR1EHpc&part=snippet,id&maxResults=20'),
        headers: {'Content-Type': 'application/json'},
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      _videos = responseData['items'];
      notifyListeners();
    } catch (e) {
      notifyListeners();
      // print(e);
    }
  }
}

Future<PermissionStatus> _getContactPermission() async {
  PermissionStatus permission = await Permission.contacts.status;
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.permanentlyDenied) {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    return permissionStatus;
  } else {
    return permission;
  }
}

void _handleInvalidPermissions(
    PermissionStatus permissionStatus, BuildContext context) {
  if (permissionStatus == PermissionStatus.denied) {
    const snackBar = SnackBar(content: Text('Access to contact data denied'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
    const snackBar =
        SnackBar(content: Text('Contact data not available on device'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
