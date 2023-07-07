import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpt/controllers/chats.dart';
import 'package:gpt/controllers/speech.dart';

class ChatsWidget extends StatelessWidget {
  ChatsWidget({
    super.key,
  });
  final chat = Get.put(Chats());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("GPT"),
      ),
      body: Obx(
        () => SingleChildScrollView(
          controller: chat.scrollTobottom,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Get.to(Speech());
                  },
                  child: const Text("next")),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: chat.chats.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: chat.chats[index][0]["role"] == "gpt"
                              ? Colors.black
                              : Colors.blue,
                          child: Text(chat.chats[index][0]["role"]!),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: index == chat.chats.length - 1 && index >= 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      chat.chats[index][0]["role"] == "gpt"
                                          ? AnimatedTextKit(
                                              onNext: (o, oo) =>
                                                  chat.goToBottom(),
                                              onFinished: () =>
                                                  chat.goToBottom(),
                                              isRepeatingAnimation: false,
                                              // totalRepeatCount: 1,
                                              animatedTexts: [
                                                  TypewriterAnimatedText(
                                                      "...."),
                                                  TypewriterAnimatedText(
                                                      chat.chats[index][0]
                                                          ["content"]!),
                                                ])
                                          : SelectableText(
                                              chat.chats[index][0]["content"]!),
                                    ],
                                  )
                                : SelectableText(
                                    chat.chats[index][0]["content"]!),
                          ),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 90, right: 90),
                      child: Divider(),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Obx(
            () => Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: chat.chatFocus,
                    onSubmitted: (value) => chat.sendQ(chat.chatCtl.text),
                    controller: chat.chatCtl,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: const InputDecoration(
                      hintText: "Demarer une converstion",
                    ),
                  ),
                ),
                chat.isText.isFalse
                    ? IconButton(
                        onPressed: () {
                          chat.speechToText.isListening
                              ? chat.stopListening()
                              : chat.startListening();
                        },
                        icon: chat.speechEnabled.isTrue
                            ? const Icon(Icons.pause_circle_filled_rounded,
                                color: Colors.green)
                            : const Icon(Icons.mic, color: Colors.blue))
                    : IconButton(
                        onPressed: () {
                          chat.sendQ(chat.chatCtl.text);
                          Get.back();
                        },
                        icon: const Icon(Icons.send))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
