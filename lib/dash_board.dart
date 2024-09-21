import 'dart:io';

import 'package:animator/widgets/image_scroller.dart';
import 'package:animator/widgets/vedio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  //-------------------------------------------------------------------------------------------------------------------
  //----------------------------------------- A P I  H A N D L I N G --------------------------------------------------
  File? image;
  File? video;
  final _picker = ImagePicker();
  bool showSpinner = false;

  //choose image source
  Future<void> chooseImageSource(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //choose vedio source
  Future<void> chooseVideoSource(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  getVideo(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Camera'),
                onTap: () {
                  getVideo(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //---------------------- G E T  I M A G E -------------------------------------------------------------------------------
  Future<void> getImage(ImageSource source) async {
    final pickedImage =
        await _picker.pickImage(source: source, imageQuality: 80);

    if (pickedImage != null) {
      image = File(pickedImage.path);
      setState(() {});
    } else {
      print("Something went wrong, couldn't upload image");
    }
  }

  //---------------------- G E T  V E D I O -------------------------------------------------------------------------------
  Future<void> getVideo(ImageSource source) async {
    final pickedVideo = await _picker.pickVideo(source: source);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
      setState(() {});
    } else {
      print("Something went wrong, couldn't upload video");
    }
  }

  //---------------------------U P L O A D  M E D I A ---------------------------------------------------------------------
  Future<void> uploadMedia() async {
    if (image == null || video == null) {
      print("Both image and video are required");
      return;
    }

    setState(() {
      showSpinner = true;
    });

    //POST API HANDLING
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.1.8:8000/api/media/'));
    request.files
        .add(await http.MultipartFile.fromPath('driving_video', video!.path));
    request.files
        .add(await http.MultipartFile.fromPath('input_image', image!.path));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    setState(() {
      showSpinner = false;
    });
  }

  //-------------------------------- C L E A R  D A T A ------------------------------------------------------------------------------
  void clear() {
    setState(() {
      image = null;
      video = null;
    });
  }
  //-----------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Animator AI.",
          style: GoogleFonts.aBeeZee(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create fun videos by uploading images and vedios.",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "A free video maker that let's you create videos in minutes.",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Upload a Driving Video (1:1 aspect ratio)',
                              style: GoogleFonts.aBeeZee(
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  video == null ? Colors.white : Colors.yellow,
                                ),
                              ),
                              onPressed: () => chooseVideoSource(context),
                              child: const Icon(
                                Icons.upload,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Upload a Portrait\n(any aspect ratio)',
                              //
                              style: GoogleFonts.aBeeZee(
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  image == null ? Colors.white : Colors.yellow,
                                ),
                              ),
                              onPressed: () => chooseImageSource(context),
                              child: const Icon(
                                Icons.upload,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ExpansionTile(
                  title: Text(
                    'Animation Instructions',
                    style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20.0, left: 20, right: 20),
                      child: Text(
                        'After uploading your video and image, click the Animate button below to generate, or click Clear to erase the inputs.',
                        style: GoogleFonts.aBeeZee(fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: uploadMedia,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 15),
                      ),
                      child: Text(
                        'Animate',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: clear,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 15),
                        side: const BorderSide(color: Colors.yellow),
                      ),
                      child: Text(
                        'Clear',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const VideoPlayerScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
