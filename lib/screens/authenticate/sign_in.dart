import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passwordmanager/model/User.dart';
import 'package:passwordmanager/services/auth.dart';
import 'package:passwordmanager/sharedFiles/constantInputDecoration.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';
import 'package:passwordmanager/sharedFiles/transitionEffect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/login_response_model.dart';
import '../../services/jsonServices.dart';
import '../../sharedFiles/optGenerator.dart';
import '../Notifications/notificationService.dart';
import '../home/OverlayMessage.dart';
import '../home/home.dart';
import 'NetworkException.dart';
import '../../sharedFiles/globals.dart' as globals;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LocalAuthentication _localAuthentication= LocalAuthentication();
  final Authservices _auth = Authservices();
  final OtpGenerator _otpgenerator = OtpGenerator();
  final APIServices _otpJson= APIServices();
  bool _obscurePassword = true;
  bool _loading = false;
  String _errorMessage = '';
  bool _isOtpEnabled = false;
  bool _isFingerPrintEnabled = false;
  bool _isFingerprintAvailiable= false;
  String? otpHash;
  bool signinWithPassword= false;
  bool signinWithFingerPrint= false;
  bool isLoginSuccessful =true;
  bool isLoginNotSuccessful= false;
  final NotificationService notificationService =NotificationService();



  @override
  void initState() {
    super.initState();
    twoFactorSettings();
    biometricSettings();
    _checkFingerprintAvialiabilty();
  }

Future<void> _checkFingerprintAvialiabilty() async{
    bool canCheckBiometrics= await _localAuthentication.canCheckBiometrics;
    bool isDevicesupported= await _localAuthentication.isDeviceSupported();
    setState(() {
      _isFingerprintAvailiable= canCheckBiometrics && isDevicesupported;
    });
}
Future<void> _authenticate()async{
    final user= FirebaseAuth.instance.currentUser;
    final email= user!.email;
    try{
      bool didAuthenticate= await _localAuthentication.authenticate(
          localizedReason: 'authenticate',
      options: AuthenticationOptions(biometricOnly: true));
      if(didAuthenticate){
        if(_isOtpEnabled) {
          final response = await APIServices.otpLogin(email!);
          if (response.data != null) {
            otpHash = response.data;
            _showEmailOtpDialog();
            _showOverlayMessage(context, "OTP sent to $email");
            print("otp sent successfull");
          }
        }else{
          Navigator.push(context, transitionEffect(page: Home()));
        }
      }else{
        _showOverlayMessage(context, "otp Failed");
      }
    }
        catch(e){
      _showOverlayMessage(context, "otp failed: $e");
      print(e);
        }
}
  Future<void> twoFactorSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOtpEnabled = prefs.getBool('otp_enabled') ?? false;
    });
  }

  Future<void> biometricSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFingerPrintEnabled = prefs.getBool('Biometric_enable') ?? false;
    });
  }

  Future<void> _updateTwoFactorSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOtpEnabled = value;
      prefs.setBool('otp_enabled', value);
      print('OTP settings updated $value');
    });
  }

  Future<void> _updateBiometricSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFingerPrintEnabled = value;
      prefs.setBool('fingerprints_enabled', value);
      print('Biometric settings updated $value');
    });
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpControllers=TextEditingController();

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    if (value == null || !regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
//get usersname for notification
  Future< Map<String, dynamic>> getUsername(BuildContext context)async{
   final FirebaseAuth getuserAuth= FirebaseAuth.instance;
   final FirebaseFirestore getuserFirestore= FirebaseFirestore.instance;
   final currentUser= getuserAuth.currentUser;
   if(currentUser == null){
     print("no user currently loggedin");
     return {"First name": "unkwon"};
   }
   final userId= currentUser?.uid;
   final userDocumentRef = getuserFirestore.collection('users').doc(userId);
   final DocumentSnapshot snapshot = await userDocumentRef.get();
   if(!snapshot.exists){
     print("no name available ");
     _showOverlayMessage(context, "no name availiable");
     return {"First name": "unknown"};
   }
   final Map<String, dynamic> userData= snapshot.data() as Map<String,dynamic>;
   return {"First name": userData["First name"] ?? "unknown"};


  }
  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final otpCode= _otpControllers.text;
      setState(() => _loading = true);
      try {
        final myUser = await _auth.sigingUser(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (myUser == null) {
          setState(() {
            _errorMessage = 'Incorrect email or password';
            _loading = false;
          });
          return;

        }
        final userData= await getUsername(context);
        final loginMessage="Login: welcome back ${userData['First name']}  ";

          if(_isOtpEnabled) {
            await _handleOtp();
            await notificationService.showNotification(userData["First name"]);
          }
          else{
            Navigator.push(context, transitionEffect(page: Home()));
            globals.longinSuccessful.add(loginMessage);
            await notificationService.showNotification(userData["First name"]);
          }

      } catch (e) {
        setState(() {
          _loading = false;
          _errorMessage = (e is NetworkException)
              ? 'Network error: check your internet connection'
              : 'Unexpected error occurred: $e';
        });
      } finally {
        if (_loading) {
          setState(() => _loading = false);
        }
      }
    }
  }


  Future<void> _handleOtp() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email != null) {
      final email = user.email;

      try {
        // Send OTP and get response
        final response = await APIServices.otpLogin(email!);

        if (response.data != null) {
          otpHash = response.data; // Store the hash in the class variable
          _showOverlayMessage(context, 'OTP sent to $email');
          print('OTP sent to $email');
          _showEmailOtpDialog();
        }
      } catch (e) {
        _showOverlayMessage(context, 'Error sending OTP: $e');
        print('Error: $e');
      }
    } else {
      _showOverlayMessage(context, 'No user email found');
      print('No user is currently logged in.');
    }
  }





  @override
  void dispose() {
    _otpControllers.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showEmailOtpDialog() {
    // Create controllers for each OTP box
    List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('OTP Verification', style: TextStyle(color:Color.fromARGB(255, 24, 146, 154)),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 35,
                    child: TextField(
                      controller: _otpControllers[index], // Use individual controllers
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: '', // Hides the counter text
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 24, 146, 154),
                          ),

                        ),
                        focusedBorder: OutlineInputBorder(
                         borderSide: BorderSide(
                           color: Color.fromARGB(255, 24, 146, 154),
                         ),
                        ),
                        fillColor: Color.fromARGB(255, 24, 146, 154)
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus(); // Move to the next field
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus(); // Move to the previous field if empty
                        }
                      },
                    ),
                  );
                }),
              ),
               SizedBox(height:15),
               Row(
                  children:[
                    Expanded(
                      child: const Text('Get verification code?', style:
                      TextStyle(
                        fontSize:20,
                        color: Color.fromARGB(255, 24, 146, 154),
                      )),
                    ),
                    TextButton(
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        final email = user?.email;
                        if (email != null) {
                          final response = await APIServices.otpLogin(email);
                          if (response.data != null) {
                            otpHash = response.data; // Update the hash
                            _showOverlayMessage(context, 'OTP sent to $email');
                            print('OTP sent to $email');
                          }
                        }
                      },
                      child: Text('Resend', style: TextStyle(fontSize: 20,color: Colors.red),),
                    ),
                  ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _auth.signOut();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red, fontSize: 20),),
            ),

        TextButton(
          onPressed: () async {
            String otp = _otpControllers.map((controller) => controller.text).join('');

            if (otp.isEmpty) {
              _showOverlayMessage(context, 'Please enter the OTP');
              return;
            }

            final user = FirebaseAuth.instance.currentUser;
            final email = user?.email;

            if (email != null && otpHash != null) {
              try {
                final response = await APIServices.otpVerify(email, otpHash!, otp);

                // Check if the API response indicates success
                if (response.data != null) {
                  _showOverlayMessage(context, 'OTP verified successfully');
                  print('OTP verified successfully');
                  Navigator.push(context, transitionEffect(page: Home()));
                } else {

                  _showOverlayMessage(context, 'Incorrect OTP. Please try again.');
                  print('Incorrect OTP entered.');
                }
              } catch (e) {
                // clear error message for network issues or other errors
                _showOverlayMessage(context, 'Incorrect OTP. Please try again.');
                print('Error: $e');
              }
            } else {
              _showOverlayMessage(context, 'No user email found or OTP hash is missing');
            }
          }



          ,
              child: const Text('Submit',style: TextStyle(color: Color.fromARGB(255, 24, 146, 154),fontSize:20),),
            ),
          ],
        );
      },
    );
  }

  void _showOverlayMessage(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 200.0,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: OverlayMessage(message: message),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const loading()
        : Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.3),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 238, 238, 238),
          flexibleSpace: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assest/topshapsdesigns.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 15),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (_isFingerPrintEnabled && !signinWithFingerPrint && !signinWithPassword) ...[
                          _buildFigerPrintOption(),

                          IconButton(
                            onPressed: () {
                              setState(() {
                                signinWithPassword = true; // Show password fields
                                signinWithFingerPrint = false; // Hide fingerprint option
                              });
                            },
                            icon: Text(
                              'Use password',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],

                        if (signinWithPassword || (!signinWithFingerPrint && !_isFingerPrintEnabled)) ...[
                          _buildEmailField(),
                          const SizedBox(height: 12),
                          _buildPasswordField(),
                          const SizedBox(height: 10),
                          Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 24, 146, 154),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Forgot your password ? ',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/Registration');
                              },
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),



                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account? ',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/Registration');
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: const Color.fromARGB(255, 24, 146, 154),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextFormField(
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          controller: _emailController,
          validator: _emailValidator,
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Email:',
            labelStyle: TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins-Regular',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: const Color.fromARGB(255, 24, 146, 154),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextFormField(
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          obscureText: _obscurePassword,
          controller: _passwordController,
          validator: _passwordValidator,
          decoration: constantInputDecoration.copyWith(
            suffixIcon: IconButton(
              onPressed: _togglePasswordVisibility,
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: _obscurePassword
                    ? Colors.grey
                    : const Color.fromARGB(255, 24, 146, 154),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Color fingerprintColor= Color.fromARGB(255, 24, 146, 154);
  Widget _buildFigerPrintOption(){
    return Container(
      child: IconButton(
        onPressed:_isFingerprintAvailiable ? _authenticate :null,
        icon: Icon(Icons.fingerprint, size: 40,
      color:  _isFingerprintAvailiable ? Color.fromARGB(255, 24, 146, 154):Colors.grey,
      ),
      ),
    );
  }
}
