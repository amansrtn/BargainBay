// ignore_for_file: camel_case_types, avoid_function_literals_in_foreach_calls, avoid_print, unused_local_variable, unused_field, unused_element, non_constant_identifier_names, duplicate_ignore, unnecessary_import

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bhashini/chat_message/getlocal_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:bhashini/Buyer/Classes/text_class.dart';
import 'package:bhashini/Buyer/Pages/entrypage.dart';
import 'package:bhashini/Buyer/Serializers/product_serializer.dart';
import 'package:bhashini/CallingScreens/incomingcall.dart';
import 'package:bhashini/Auth/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kplayer/kplayer.dart';

class callerscreen extends StatefulWidget {
  const callerscreen({super.key, this.prod, this.chatmsg});
  final Product? prod;
  final Map<String, dynamic>? chatmsg;
  @override
  State<callerscreen> createState() => _callerscreenState();
}

TextClass textclass = TextClass();
bool cansenddata = false;
int _recordDuration = 0;
Timer? _timer;
AudioRecorder _audioRecorder = AudioRecorder();
StreamSubscription<RecordState>? _recordSub;
RecordState _recordState = RecordState.stop;
StreamSubscription<Amplitude>? _amplitudeSub;
Amplitude? _amplitude;

Future<String> _getPath() async {
  final dir = await getApplicationDocumentsDirectory();
  return p.join(
    dir.path,
    'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
  );
}

Future<void> deleteCollection(String collectionPath) async {
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(collectionPath).get();

  for (final DocumentSnapshot doc in snapshot.docs) {
    await doc.reference.delete();
  }
}

Future<Uint8List> fetchAudioContent(String msg) async {
  const String url =
      'https://dhruva-api.bhashini.gov.in/services/inference/pipeline';

  final Map<String, String> headers = {
    'Authorization':
        'Emyr4gTgApuoM02xmqq2MeUB4DveWFxy10DMTAVXppCW0-msLYPQ3BNW1s8T_KMv',
    'Content-Type': 'application/json',
  };

  final Map<String, dynamic> payload = {
    "pipelineTasks": [
      {
        "taskType": "tts",
        "config": {
          "language": {"sourceLanguage": "hi"},
          "serviceId": "ai4bharat/indic-tts-coqui-indo_aryan-gpu--t4",
          "gender": "female",
        },
      }
    ],
    "inputData": {
      "input": [
        {"source": msg}
      ]
    },
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final audioContent =
        data['pipelineResponse'][0]['audio'][0]['audioContent'];
    return base64Decode(audioContent);
  } else {
    throw Exception('Failed to fetch audio content');
  }
}

// audio by reciver
Future<void> playAudio(String msg) async {
  final audioContent = await fetchAudioContent(msg);
  print(audioContent);
  var player = Player.bytes(audioContent);
}

// asr
Future<String> asrcalling(String base64) async {
  const String url =
      "https://dhruva-api.bhashini.gov.in/services/inference/pipeline";

  final Map<String, String> headers2 = {
    "Authorization":
        "Emyr4gTgApuoM02xmqq2MeUB4DveWFxy10DMTAVXppCW0-msLYPQ3BNW1s8T_KMv",
    "Content-Type": "application/json",
  };

  final Map<String, dynamic> payload2 = {
    "pipelineTasks": [
      {
        "taskType": "asr",
        "config": {
          "language": {"sourceLanguage": "en"},
          "serviceId": "ai4bharat/whisper-medium-en--gpu--t4",
          "samplingRate": 16000,
        },
      }
    ],
    "inputData": {
      "audio": [
        {"audioContent": base64}
      ]
    },
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers2,
    body: jsonEncode(payload2),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    String audio_content = data["pipelineResponse"][0]["output"][0]["source"];
    print("data $audio_content");
    return audio_content;
  } else {
    print(response.statusCode);
    return response.statusCode.toString();
  }
}

class _callerscreenState extends State<callerscreen> {
  @override
  void initState() {
    checkuser();
    _audioRecorder = AudioRecorder();

    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      _updateRecordState(recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
      // setState(() => _amplitude = amp);
      _amplitude = amp;
    });
    _start();
    super.initState();
  }

  Future<void> recordFile(AudioRecorder recorder, RecordConfig config) async {
    final path = await _getPath();

    await recorder.start(config, path: path);
  }

  Future<void> recordStream(AudioRecorder recorder, RecordConfig config) async {
    final path = await _getPath();

    final file = File(path);

    final stream = await recorder.startStream(config);

    stream.listen(
      (data) {
        // ignore: avoid_print
        print(
          recorder.convertBytesToInt16(Uint8List.fromList(data)),
        );
        file.writeAsBytesSync(data, mode: FileMode.append);
      },
      // ignore: avoid_print
      onDone: () {
        // ignore: avoid_print
        print('End of stream. File written to $path.');
      },
    );
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        const encoder = AudioEncoder.wav;

        if (!await _isEncoderSupported(encoder)) {
          return;
        }

        final devs = await _audioRecorder.listInputDevices();
        debugPrint(devs.toString());

        const config = RecordConfig(encoder: encoder, numChannels: 1);

        // Record to file
        await recordFile(_audioRecorder, config);

        // Record to stream
        // await recordStream(_audioRecorder, config);

        _recordDuration = 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    final path = await _audioRecorder.stop();
    File audioFile = File(path ?? "");
    List<int> audioBytes = await audioFile.readAsBytes();
    String base64Audio = base64Encode(audioBytes);
    String outputtext = await asrcalling(base64Audio);
    // print(base64Audio);
    // print(outputtext);
    sendmessage(outputtext);
    // playAudio(outputtext);
  }

  Future<void> sendmessage(String message) async {
    bool? usertype = await type();
    if (usertype == false) {
      FirebaseFirestore.instance.collection("chat_personal").add({
        "text": message,
        "createdAt": Timestamp.now(),
        "user_id": FirebaseAuth.instance.currentUser!.uid,
        "sender_email": await buyergetuseremail(),
        "reciver_email": widget.prod?.seller_email,
        "reciver_lang": widget.prod?.seller_lang,
        "reciver_gender": widget.prod?.seller_gender,
        "reciver_name": widget.prod?.sellerFName,
        "sender_name": await buyergetname(),
        "sender_lang": await buyergetlang(),
        "sender_gender": await buyergetusertype()
      });
    } else {
      FirebaseFirestore.instance.collection("chat_personal").add({
        "text": message,
        "createdAt": Timestamp.now(),
        "user_id": FirebaseAuth.instance.currentUser!.uid,
        "sender_email": await sellergetuseremail(),
        "reciver_email": widget.chatmsg!["sender_email"],
        "reciver_lang": widget.chatmsg!["sender_lang"],
        "reciver_gender": widget.chatmsg!["sender_gender"],
        "reciver_name": widget.chatmsg!["sender_name"],
        "sender_name": await sellergetname(),
        "sender_lang": await sellergetlang(),
        "sender_gender": await sellergetusertype()
      });
    }
  }

  void _updateRecordState(RecordState recordState) {
    _recordState = recordState;

    switch (recordState) {
      case RecordState.pause:
        _timer?.cancel();
        break;
      case RecordState.record:
        break;
      case RecordState.stop:
        _timer?.cancel();
        _recordDuration = 0;
        break;
    }
  }

  bool islistening = true;
  Future<bool> _isEncoderSupported(AudioEncoder encoder) async {
    final isSupported = await _audioRecorder.isEncoderSupported(
      encoder,
    );

    if (!isSupported) {
      debugPrint('${encoder.name} is not supported on this platform.');
      debugPrint('Supported encoders are:');

      for (final e in AudioEncoder.values) {
        if (await _audioRecorder.isEncoderSupported(e)) {
          debugPrint('- ${encoder.name}');
        }
      }
    }

    return isSupported;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat_personal")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (cx, chatsnap) {
          if (chatsnap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (!chatsnap.hasData || chatsnap.data!.docs.isEmpty) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Scaffold(
                    backgroundColor: Colors.green[100],
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: getUnitHeight(context) * 7)),
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/images/clock.png'),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: getUnitHeight(context) * 3)),
                        Center(
                          child: Text(
                              widget.prod == null
                                  ? "Call Picked"
                                  : widget.prod!.sellerFName,
                              style: textclass.title),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom: getUnitHeight(context) * 30)),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              color: Colors.indigo[900],
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: getUnitHeight(context),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.mic_none_rounded,
                                          size: 50,
                                        ),
                                        color: white,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Image(
                                          image: AssetImage(
                                              "assets/images/speaker.png"),
                                          height: 40,
                                          width: 40,
                                        ),
                                        color: white,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Image(
                                          image: AssetImage(
                                              "assets/images/videocamera.png"),
                                          height: 40,
                                          width: 40,
                                        ),
                                        color: white,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom: getUnitHeight(context) * 3)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _stop();
                                        },
                                        icon: const Image(
                                          image: AssetImage(
                                              "assets/images/adduser.png"),
                                          height: 40,
                                          width: 40,
                                        ),
                                        color: white,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom: getUnitHeight(context) * 4)),
                                  Center(
                                    child: IconButton(
                                      onPressed: () {
                                        deleteCollection('call');
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const EntryPage()));
                                      },
                                      icon: const Image(
                                        image: AssetImage(
                                            "assets/images/endcall.png"),
                                        height: 70,
                                        width: 70,
                                      ),
                                      color: white,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: double.infinity,
                                  // )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ],
            );
          }
          if (chatsnap.hasError) {
            return const Center(
              child: Text(
                "Something Went Wrong.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          cansenddata = true;
          final loadedmsg = chatsnap.data!.docs;
          //     "text": message,
          // "createdAt": Timestamp.now(),
          // "user_id": FirebaseAuth.instance.currentUser!.uid,
          // "sender_email": await sellergetuseremail(),
          // "reciver_email": widget.prod?.seller_email,
          // "reciver_lang": widget.prod?.seller_lang,
          // "reciver_gender": widget.prod?.seller_gender,
          // "reciver_name": widget.prod?.sellerFName,
          // "sender_name": await sellergetname(),
          // "sender_lang": await sellergetlang(),
          // "sender_gender": await sellergetusertype()
          String message = loadedmsg[0].data()["text"];
          final cuser = loadedmsg[0].data()["reciver_email"];
          if (useremail == cuser) {
            playAudio(message);
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              Scaffold(
                  backgroundColor: Colors.green[100],
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: getUnitHeight(context) * 7)),
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/clock.png'),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: getUnitHeight(context) * 3)),
                      Center(
                        child: Text("Call Picked", style: textclass.title),
                      ),
                      Center(
                        child: islistening
                            ? Text("Listening", style: textclass.title)
                            : Text("Stopped", style: textclass.title),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: getUnitHeight(context) * 30)),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            color: Colors.indigo[900],
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: getUnitHeight(context),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _start();
                                      },
                                      icon: const Icon(
                                        Icons.mic_none_rounded,
                                        size: 50,
                                      ),
                                      color: white,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Image(
                                        image: AssetImage(
                                            "assets/images/speaker.png"),
                                        height: 40,
                                        width: 40,
                                      ),
                                      color: white,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Image(
                                        image: AssetImage(
                                            "assets/images/videocamera.png"),
                                        height: 40,
                                        width: 40,
                                      ),
                                      color: white,
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: getUnitHeight(context) * 3)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _stop();
                                      },
                                      icon: const Image(
                                        image: AssetImage(
                                            "assets/images/adduser.png"),
                                        height: 40,
                                        width: 40,
                                      ),
                                      color: white,
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: getUnitHeight(context) * 4)),
                                Center(
                                  child: IconButton(
                                    onPressed: () {
                                      deleteCollection('call');
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const EntryPage()));
                                    },
                                    icon: const Image(
                                      image: AssetImage(
                                          "assets/images/endcall.png"),
                                      height: 70,
                                      width: 70,
                                    ),
                                    color: white,
                                  ),
                                ),
                                // SizedBox(
                                //   height: double.infinity,
                                // )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
          );
        });
  }
}
