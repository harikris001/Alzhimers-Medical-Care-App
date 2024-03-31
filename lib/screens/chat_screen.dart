import 'dart:async';

import 'package:flutter/material.dart';
import 'package:alzhcare/models/chat_message.dart';
import 'package:alzhcare/utils/sender_enum.dart';
import 'package:alzhcare/widgets/chat_title_tile.dart';
import 'package:alzhcare/widgets/message_tile.dart';
import 'package:alzhcare/widgets/message_type_writer_tile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();

  bool scrollPositionIsBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          scrollPositionIsBottom = false;
        } else {
          // print('You are at the bottom of the ListView');
          scrollPositionIsBottom = true;
        }
      } else {
        // print('You are not at the edges');
        scrollPositionIsBottom = false;
      }
    });
  }

  Timer? timer;

  Future<void> sendMessage(String messageText) async {
    setState(() {
      loading = true;
    });

    chat.add(ChatMessage(message: messageText, sender: Sender.user));
    chat.add(ChatMessage(message: '', sender: Sender.user));
    activeIndex = chat.length - 1;

    setState(() {
      messageUpdated();
    });

    String generatedText = await generateText(messageText);
    startTimer();
    // print('generated text: $generatedText');
    chat[activeIndex] = ChatMessage(message: generatedText, sender: Sender.bot);
    setState(() {
      messageUpdated();
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (scrollPositionIsBottom) {
        messageUpdated();
      }
    });
  }

  void resetTimer() {
    timer?.cancel();
  }

  void resetIndex() {
    setState(() {
      resetTimer();
      activeIndex = -1;
      loading = false;
    });
  }

  void messageUpdated() {
    if (_scrollController.positions.isNotEmpty) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  bool loading = false;

  List<ChatMessage> chat = [];

  int activeIndex = -1;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double screenHeight = MediaQuery.of(context).size.height;

    double bodyHeight = screenHeight - appBarHeight;
    double bodyWidth = MediaQuery.of(context).size.width;
    double bodyPadding = bodyWidth * 0.05;
    double inputfontSize = bodyHeight * 0.018;
    double minInputBoxHeight = bodyHeight * 0.05;

    double iconSize = bodyWidth * 0.05;
    double iconPadding = bodyWidth * 0.01;

    double drawerWidth = bodyWidth * 0.8;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('AlzhCare-'),
            Text(
              'Personal Companion',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  chat.clear();
                  resetIndex();
                });
              },
              icon: const Icon(Icons.refresh_outlined))
        ],
      ),
      drawerEnableOpenDragGesture: true,
      drawer: Drawer(
        width: drawerWidth,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(bodyPadding),
            child: Column(
              children: [
                DrawerHeader(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                  child: const Center(
                    child: Text(
                      "Though those with alzheimer's might forget us, we as a society must remeber them",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
                const SizedBox(height: 15.0),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(iconPadding),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (MediaQuery.of(context)
                                            .platformBrightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white)),
                            child: Icon(
                              Icons.model_training,
                              color:
                                  (MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black),
                              size: iconSize,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Ask to Companion',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(iconPadding),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (MediaQuery.of(context)
                                            .platformBrightness ==
                                        Brightness.light
                                    ? Colors.white
                                    : Colors.black)),
                            child: Icon(
                              Icons.window,
                              color:
                                  (MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                              size: iconSize,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Detect Alzhimers',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'FAQ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.grey),
                      ),
                      const ChatTitleTile(chatTitle: 'What is alzchimer?'),
                      const ChatTitleTile(
                          chatTitle: 'How to deal with alzchimers?'),
                      const ChatTitleTile(
                          chatTitle: 'Proper Medicine for alzchimers?'),
                      const ChatTitleTile(
                          chatTitle:
                              'How much people are affected by alzchimers?'),
                      const ChatTitleTile(
                          chatTitle: 'Easy Detection for alzchimers?'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: bodyPadding),
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: chat.isEmpty
                    ? Center(
                        child: Text(
                          'Start Chat',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey, fontSize: 30),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        itemCount: chat.length,
                        itemBuilder: (context, index) {
                          if (index == activeIndex) {
                            return chat[index].message.isEmpty
                                ? TypeWriterWidgetWithLoader(
                                    onComplete: () {},
                                    message: "",
                                  )
                                : TypeWriterWidgetWithLoader(
                                    onComplete: resetIndex,
                                    message: chat[index].message);
                          }
                          return MessageTile(chatMessage: chat[index]);
                        },
                      ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: _messageController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      enabled: !loading,
                      maxLines: 9,
                      minLines: 1,
                      style: Theme.of(context).textTheme.bodyMedium,
                      cursorHeight: inputfontSize,
                      cursorColor: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Feel free to ask',
                        suffixIcon: _messageController.text.isEmpty
                            ? const Icon(Icons.question_mark_rounded)
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: bodyPadding / 3),
                    child: IconButton(
                      alignment: Alignment.center,
                      iconSize: minInputBoxHeight * 0.8,
                      onPressed: loading
                          ? null
                          : () async {
                              if (_messageController.text.isNotEmpty) {
                                sendMessage(_messageController.text);
                                _messageController.clear();
                              }
                            },
                      icon: Icon(
                        _messageController.text.isEmpty
                            ? Icons.medical_services_rounded
                            : Icons.send,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.grey.shade100,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> generateText(String prompt) async {
    String url = 'https://api.openai.com/v1/chat/completions';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer '
      },
      body: jsonEncode({
        'messages': [
          {
            "role": "user",
            "content":
                "'I am an AI designed to be a helpful and supportive companion to alzchimers patients. You can ask me anything, and I will do my best to provide a helpful and humble response. I will not generate inappropriate or offensive responses. I am here to assist you in a positive and uplifting way. I will not generate redundant information: if I know enough to confidently follow the instruction. The replies will be like an emotionally support friend for the patient. I will not answer if i donot have any proper knowledge about how to deal with the situation. The question from the patient is : $prompt"
          }
        ],
        'model': 'gpt-3.5-turbo',
        'max_tokens': 1000,
        'temperature': 0,
        'top_p': 1,
      }),
    );
    try {
      String responseText =
          jsonDecode(response.body)['choices'][0]['message']['content'];
      return responseText;
    } catch (e) {
      return 'some error occurred, try again later';
    }
  }
}
