
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



import 'settings_subpages/password_recovery.dart';
import 'settings_subpages/data_privacy.dart';
import 'settings_subpages/faq.dart';

import '../login_page.dart'; 



class SettingsPage extends StatefulWidget {
  final Function(int) onNavigate;
  final int selectedIndex;

  const SettingsPage({required this.onNavigate, required this.selectedIndex, Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Uint8List? _profileImage; 
  bool _isLoading = false; 


  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  
  String _email = '';
  String _name = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    //_loadProfileImage();
     _fetchUserInfo();

  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }



  Future<void> _fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          nameController.text = data['name'] ?? 'User';
          emailController.text = data['email'] ?? 'user@example.com';
          phoneController.text = data['phone'] ?? '000-000-0000';
        });
      }
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




  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false, ); 

    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error signing out')),
      );
    }
  }



  
Future<void> _showPasswordErrorDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Incorrect Password',
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      content: Text(
        'The password you entered is incorrect. Please try again.',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: Text(
            'Try Again',
            style: TextStyle(
              color: const Color.fromARGB(255, 72, 74, 72),
            ),
          ),
        ),
      ],
    ),
  );
}


Future<bool> _validatePassword(String password) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is signed in.');
      return false;
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!, 
      password: password, 
    );

    await user.reauthenticateWithCredential(credential);
    return true; 
  } catch (e) {
    print("Error during password validation: $e");
    return false; 
  }
}


Future<bool> _showPasswordDialog(BuildContext context) async {
  TextEditingController passwordController = TextEditingController();
  bool isConfirmed = false;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Confirm Deletion',
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter your password to confirm:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color.fromARGB(255, 72, 74, 72)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: const Color.fromARGB(255, 71, 71, 71),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            String password = passwordController.text;

            // Validate the password
            bool isPasswordValid = await _validatePassword(password);

            if (isPasswordValid) {
              isConfirmed = true;
              Navigator.of(context).pop(); 
            } else {
              Navigator.of(context).pop(); 
              await _showPasswordErrorDialog(context); 
            }
          },
          child: Text(
            'Confirm',
            style: TextStyle(
              color: const Color.fromARGB(255, 42, 41, 41),
            ),
          ),
        ),
      ],
    ),
  );

  return isConfirmed; 
}


Future<void> _deleteUserAccount(BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      bool isPasswordValid = await _showPasswordDialog(context);

      if (!isPasswordValid) {
        print('Incorrect password, account deletion canceled');
        return;
      }

      await _deleteUserData(user.uid);

      await _deleteUserProfileImage(user.uid);


      try {
        await user.delete();
        print('User account deleted successfully!');
      } catch (e) {
        print('Error during account deletion: $e');
        return; 
      }


      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false, ); 

    }
  } catch (e) {
    print('Error deleting user account: $e');
  }
}


Future<void> _deleteUserData(String uid) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
  } catch (e) {
    print('Error deleting user data from Firestore: $e');
  }
}


Future<void> _deleteUserProfileImage(String uid) async {
  try {
    await FirebaseStorage.instance.ref('profile_images/$uid').delete();
  } catch (e) {
    print('Error deleting user profile image from Firebase Storage: $e');
  }
}



/*load image from firebase -- having error retrieving, can upload to firebase fine. possibly a CORS problem? fix when possible


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
  
   */






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
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const SizedBox(height: 12.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    TextButton(
                       onPressed: () async {
                        if (isEditing) {
                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final uid = user.uid; 

                              if (emailController.text != user.email) {
                                try {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false, 
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Email Change Verification'),
                                        content: Text(
                                          'Please check your email account for a verification email. '
                                          'You must verify your new email address before we can update it.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); 
                                            },
                                            child: Text('Okay'),
                                          ),
                                        ],
                                      );
                                    },
                                  );


                                  await user.verifyBeforeUpdateEmail(emailController.text);
                                } catch (error) {
                                  print("Error updating email in Firebase Authentication: $error");
                                  return; 
                                }
                              }


                              await FirebaseFirestore.instance.collection('users').doc(uid).set({
                                'name': nameController.text,
                                'email': emailController.text,
                                'phone': phoneController.text,
                              }, SetOptions(merge: true));

                            } else {
                              print("No authenticated user found.");
                            }
                          } catch (error) {
                            print("Error updating user profile: $error");
                          }
                        }


                        setState(() {
                          isEditing = !isEditing;
                        });
                      },


                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 197, 200, 195),
                          foregroundColor: const Color.fromARGB(255, 56, 58, 55), 
                        
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),  
                          ),

           
                          side: const BorderSide(
                            color:const Color(0xFF383C35),
                            width: 1.2,  
                          ),
                        ),

                        child: Text(
                          isEditing ? "Stop Editing" : "Edit Profile",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),



                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Currency: ",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF424F42),
                          ),
                        ),
                        Text(
                           
                          "US Dollar (\$)",
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 133, 138, 130),
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              ),

              const SizedBox(height: 22.0),

              Center(
                child: Column(
  
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,  
                            border: Border.all(
                              color:Color.fromARGB(255, 46, 48, 46),  
                              width: 2.5,          
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImage != null
                                ? MemoryImage(_profileImage!) 
                                : const AssetImage('images/default_pfp.png') as ImageProvider,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                : null,
                          ),
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
                
                  isEditing
                      ? Center( 
                          child: SizedBox(
                            width: 150, 
                            child: TextFormField(
                              controller: nameController,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: const Color.fromARGB(255, 77, 77, 77),

                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: const Color.fromARGB(255, 72, 72, 72)), 
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black), 
                                ),
                              ),
                            ),
                          ),
                        )
                      : Text(
                          nameController.text.isNotEmpty ? nameController.text : 'User Name',
                          textAlign: TextAlign.center, 
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                    const SizedBox(height: 6.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !isEditing
                            ? const Text(
                                "Email: ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF424F42),
                                ),
                              )
                            : SizedBox(), 

                        isEditing
                            ? Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center, 
                                  children: [
                                    Center(  
                                      child: Container(
                                        width: 250, 
                                        child: TextFormField(
                                          controller: emailController,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: const Color.fromARGB(255, 77, 77, 77),
                                          ),
                                          textAlign: TextAlign.center, 
                                          decoration: InputDecoration(
                                            hintText: 'Email', 
                                            hintStyle: TextStyle(color: Colors.grey), 
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(top: 1.0),
                                      height: 1.0,
                                      width: 250, 
                                      color:  const Color.fromARGB(255, 72, 72, 72), 
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                emailController.text.isNotEmpty
                                    ? emailController.text
                                    : 'user@example.com',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 133, 138, 130),
                                ),
                              ),
                      ],
                    ),

                    const SizedBox(height: 4.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !isEditing
                            ? const Text(
                                "Phone Number: ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF424F42),
                                ),
                              )
                            : SizedBox(), 

                        isEditing
                            ? Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(  
                                      child: Container(
                                        width: 250, 
                                        child: TextFormField(
                                          controller: phoneController,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: const Color.fromARGB(255, 77, 77, 77),
                                          ),
                                          textAlign: TextAlign.center,  
                                          decoration: InputDecoration(
                                            hintText: 'Phone Number', 
                                            hintStyle: TextStyle(color: Colors.grey), 
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 1.0),
                                      height: 1.0,
                                      width: 250, 
                                      color:  const Color.fromARGB(255, 72, 72, 72), 
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                phoneController.text.isNotEmpty
                                    ? phoneController.text
                                    : '000-000-0000',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 133, 138, 130),
                                ),
                              ),
                      ],
                    ),


                  ],
                ),
              ),
        
              const SizedBox(height: 25.0),

              Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFB7B9B7),
                    border: const Border(
                        top: BorderSide(color: Color(0xFF2D372D), width: 2.0), 
                        bottom:BorderSide(color: Color(0xFF2D372D), width: 1.0), 
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 39, 39, 39),
                      ),
                    ),
                  ),
                ),


                Padding(
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),  
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4E4E4),
                        border: const Border(
                          bottom: BorderSide(color: Color(0xFF2D372D), width: 2.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: const Text("Password & Recovery"),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PasswordRecoveryPage()),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.privacy_tip),
                            title: const Text("Data Privacy"),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DataPrivacyPage()),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.question_answer),
                            title: const Text("FAQ"),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FAQPage()),
                              );
                            },
                          ),
                       
                        ],
                      ),
                    ),
                  ),

    
              const SizedBox(height: 20.0),
             
     
               Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 92, 97, 93),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.black, width: 1.5), 
                      ),
                       elevation: 5.0,
                    ),
                    onPressed: () => _signOut(context), 
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 16.0),
                   
                    ),
                  ),
                ),


               const SizedBox(height: 2.0),


               Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 138, 31, 23),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.black, width: 1.5), 
                      ),
                       elevation: 5.0,
                    ),
                    onPressed: () => _deleteUserAccount(context),
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(fontSize: 16.0),
                   
                    ),
                  ),
                ),

              const SizedBox(height: 10.0),

            ],
          ),
        ),
      ),
    );
  }
}