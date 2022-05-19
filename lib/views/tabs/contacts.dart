import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sankore_task/constants/app_colors.dart';
import 'package:sankore_task/providers/data_provider.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({Key? key}) : super(key: key);

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  bool loading = false;

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    Provider.of<DataProvider>(context, listen: false)
        .getContacts(context)
        .then((value) => setState(() {
              setState(() {
                loading = false;
              });
            }));
    super.initState();
  }

  // Future<void> _askPermissions() async {
  //   PermissionStatus permissionStatus = await _getContactPermission();
  //   if (permissionStatus == PermissionStatus.granted) {
  //     getAllContacts().then((value) => setState(() {
  //           loading = false;
  //         }));
  //   } else {
  //     _handleInvalidPermissions(permissionStatus);
  //   }
  // }

  // Future<PermissionStatus> _getContactPermission() async {
  //   PermissionStatus permission = await Permission.contacts.status;
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.permanentlyDenied) {
  //     PermissionStatus permissionStatus = await Permission.contacts.request();
  //     return permissionStatus;
  //   } else {
  //     return permission;
  //   }
  // }

  // void _handleInvalidPermissions(PermissionStatus permissionStatus) {
  //   if (permissionStatus == PermissionStatus.denied) {
  //     const snackBar = SnackBar(content: Text('Access to contact data denied'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
  //     const snackBar =
  //         SnackBar(content: Text('Contact data not available on device'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }

  // Future<void> getAllContacts() async {
  //   List<Contact> _contacts = (await ContactsService.getContacts()).toList();
  //   setState(() {
  //     contacts = _contacts;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final List<Contact> _contacts = Provider.of<DataProvider>(context).contacts;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Contacts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: loading && _contacts.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 20.0 * _contacts.length),
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      Contact contact = _contacts[index];
                      return contact.displayName == null
                          ? Container()
                          : ListTile(
                              title: contact.displayName != null
                                  ? Text(contact.displayName!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ))
                                  : const SizedBox(),
                              horizontalTitleGap: 15,
                              subtitle: contact.phones!.isNotEmpty
                                  ? Text(contact.phones!.elementAt(0).value!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ))
                                  : null,
                              leading: (contact.avatar != null &&
                                      contact.avatar!.isNotEmpty)
                                  ? CircleAvatar(
                                      backgroundImage:
                                          MemoryImage(contact.avatar!),
                                    )
                                  : CircleAvatar(
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.7),
                                      child: Text(
                                        contact.initials() != ''
                                            ? contact.initials()
                                            : contact.displayName != null
                                                ? contact.displayName![0]
                                                : '',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                            );
                    },
                  );
                },
              ),
      ),
    );
  }
}
