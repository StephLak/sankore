import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:provider/provider.dart';
import 'package:sankore_task/constants/app_colors.dart';
import 'package:sankore_task/providers/data_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class SmsTab extends StatefulWidget {
  const SmsTab({Key? key}) : super(key: key);

  @override
  State<SmsTab> createState() => _SmsTabState();
}

class _SmsTabState extends State<SmsTab> {
  bool loading = false;

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    Provider.of<DataProvider>(context, listen: false)
        .getMessages()
        .then((value) => setState(() {
              loading = false;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<SmsMessage> _messages =
        Provider.of<DataProvider>(context).messages;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: loading && _messages.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 10),
                shrinkWrap: true,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int i) {
                  final SmsMessage message = _messages[i];
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Text(
                            message.sender![0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.8,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      message.sender!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      timeago.format(message.date!),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                message.body!,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );

                  // return ListTile(
                  //   title: Text('${message.sender} [${message.sender}]'),
                  //   subtitle: Text('${message.body}'),
                  // );
                },
              ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {},
      //   child: const Icon(Icons.refresh),
      // ),
    );
  }
}
