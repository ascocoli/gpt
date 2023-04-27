import 'dart:async';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Chats extends GetxController {
  ScrollController scrollTobottom = ScrollController();
  RxBool isText = false.obs;
  FocusNode chatFocus = FocusNode();

  TextEditingController chatCtl = TextEditingController();
  RxList<List<Map<String, String>>> chats = [
    [
      {
        "role": "gpt",
        "content": "BonJour ! Comment je peux vous aidez ?",
      },
      {"finish_reason": "top"},
    ],
  ].obs;
  //for speech variables
  SpeechToText speechToText = SpeechToText();
  RxBool speechEnabled = true.obs;
  RxString lastWords = ''.obs;

  sendQ(q) {
    if (chats.last[0]["content"] != q) {
      chats.add([
        {
          "role": "user",
          "content": q,
        },
        {"finish_reason": "top"},
      ]);
    }

    chatComplete(q);
    scrollTobottom.animateTo(scrollTobottom.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  final openAI = OpenAI.instance.build(
      token:
          "sk-itJzVwfSIIQMAJfa9MXDT3BlbkFJeAnRXidwPpfkf84dWAoqana-itJzVwfSIIQMAJfa9MXDT3BlbkFJ",
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
      isLog: true);
  void _onFocusChange() {
    isText.value = chatFocus.hasFocus;
  }

  void chatComplete(question) async {
    final request = ChatCompleteText(
      messages: [
        Map.of({"role": "user", "content": question}),
      ],
      maxToken: 200,
      model: ChatModel.gptTurbo0301,
    );

    final response = await openAI.onChatCompletion(request: request);
    if (response!.choices.isNotEmpty) {
      chatCtl.clear();
      chats.add([
        {
          "role": "gpt",
          "content": response.choices[0].message!.content,
        },
        {"finish_reason": "top"},
      ]);
    }
  }

  goToBottom() {
    scrollTobottom.animateTo(scrollTobottom.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  // for speech text
  void initSpeech() async {
    speechEnabled.value = await speechToText.initialize(
      onError: (e) {
        print("error $e");
      },
      onStatus: (e) {
        print("state $e");
      },
    );

    // final PermissionStatus permis = await _getPhonePermission();
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    print("hello");

    await speechToText.listen(onResult: _onSpeechResult);
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    // print("Voici le mot${lastWords}");
    await speechToText.stop();
    Timer(const Duration(seconds: 2), () {
      sendQ(lastWords.value);
    });

    speechEnabled.value = false;
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords.value = result.recognizedWords;
    print(result.recognizedWords);
  }

  @override
  void onInit() {
    super.onInit();
    initSpeech();
    chatFocus.addListener(_onFocusChange);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    chatFocus.removeListener(_onFocusChange);
    chatFocus.dispose();
  }
}


//{role: assistant, content: Je suis une IA et je ne peux pas écrire de code. Mais voici le code "Hello World" en PHP :
// <?php
// echo "Hello World!";
// ?>}, finish_reason: stop}