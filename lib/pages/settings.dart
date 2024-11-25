
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SettingsPage extends StatefulWidget {
  final Function(int) onNavigate;
  final int selectedIndex;

  const SettingsPage({required this.onNavigate, required this.selectedIndex, Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Uint8List? _profileImage; //local profile image in memory
  bool _isLoading = false; //to indicate loading while fetching/uploading image

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  //load image from firebase -- having error retrieving, can upload to firebase fine. fix when possible
  Future<void> _loadProfileImage() async {
    setState(() => _isLoading = true); //show loading indicator

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final ref = FirebaseStorage.instance.ref('profile_images/$userId');
        final Uint8List? downloadedImage = await ref.getData();
        if (downloadedImage != null) {
          setState(() => _profileImage = downloadedImage);
        }
      }
    } catch (e) {
      print("Error loading profile image: $e");
    } finally {
      setState(() => _isLoading = false); 
    }
  }


  //upload image to firebase
  Future<void> _pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _profileImage = imageBytes; 
          _isLoading = true; 
        });

        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          final ref = FirebaseStorage.instance.ref('profile_images/$userId');
          await ref.putData(imageBytes); 
          print("Profile image uploaded successfully.");
        }
      }
    } catch (e) {
      print("Error picking or uploading image: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color.fromARGB(255, 23, 28, 24), 
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? MemoryImage(_profileImage!) //display image
                              : const AssetImage('images/default_pfp.png') as ImageProvider,
                          child: _isLoading 
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _pickAndUploadImage,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      "User Name",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Email: ",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 109, 109, 109),
                          ),
                        ),
                        Text(
                          "user@example.com",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),


                    

                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Phone Number: ",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 109, 109, 109),
                          ),
                        ),
                        Text(
                          "000-000-0000",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              ),


              

              
              const SizedBox(height: 50.0),

              //settings section
              Center(
                child: const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

  
              Container(
                color: Colors.grey[200],
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text("Password & Recovery"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        //navigate to page with password and recovery settings
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip),
                      title: const Text("Data Privacy"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        //navigate to page with data privacy information 
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.question_answer),
                      title: const Text("FAQ"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        //navigate to page with FAQ 
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email), 
                      title: const Text("Contact Support"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        //navigate to page with contact support
                      },
                    ),
                  ],
                ),
              ),

        
              const SizedBox(height: 40.0),

              //delete account button
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0), 
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 138, 31, 23), 
                    foregroundColor: Colors.white, 
                    padding: const EdgeInsets.symmetric(vertical: 16.0), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), //rounded corners
                    ),
                  ),
                  onPressed: () {
                    //add delete account functionality here
                  },
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),




            ],
          ),
        ),
      ),
    );
  }
}


