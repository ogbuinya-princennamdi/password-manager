import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passwordmanager/screens/home/settings/securitySettings/changePassword.dart';
import 'package:passwordmanager/services/auth.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';
import 'package:passwordmanager/sharedFiles/transitionEffect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../OverlayMessage.dart';
import 'addFingerPrint.dart';

class SecuritySetting extends StatefulWidget {
  const SecuritySetting({Key? key}) : super(key: key);

  @override
  State<SecuritySetting> createState() => _SecuritySettingState();
}

class _SecuritySettingState extends State<SecuritySetting> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _verifyEmailWithPassword = TextEditingController();

  Color _profileSettingsColor = Colors.grey.withOpacity(0.5);
  Color _editProfileColor = Colors.grey.withOpacity(0.5);

  bool _isEditFingerprint = false;
  bool _isFingerPrintEnabled = false;
  bool _isUserAuthenticated = false;
  bool _obscureText = false;
  bool _loading = false;
  bool _isEditPassword = false;
  bool _isEdit2FA = false;
  bool _isSecurity = false;
  bool _isOtpEnabled = false;

  String? get email => FirebaseAuth.instance.currentUser?.email;

  @override
  void initState() {
    super.initState();
    twoFactorSettings();
    BiometricSettings();

  }

  @override
  Widget build(BuildContext context) {
    double screenWidthSizes= MediaQuery.of(context).size.width;
    double screenHeightSizes=MediaQuery.of(context).size.height;
    return Column(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSecurity = !_isSecurity;
              _profileSettingsColor = _isSecurity
                  ? const Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)
                  : Colors.grey.withOpacity(0.5);
            });
          },
          icon: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.security,
                  size: 40,
                  color: _isSecurity ? _profileSettingsColor : const Color.fromARGB(255, 24, 146, 154),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isSecurity ? _profileSettingsColor : null,
                      ),
                    ),
                    Text(
                      'Add fingerprint, password, 2FA',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 19,
                        color: _isSecurity ? _profileSettingsColor : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isSecurity) ...[
          _buildSecurityOption(
            screenWidthSizes:screenWidthSizes *0.9,
            icon: Icons.lock_clock,
            title: 'Change Password',
            onTap: () {
              Navigator.pushNamed(context, '/changePassword');
              setState(() {
                _isEditPassword = !_isEditPassword;
                _editProfileColor = _isEditPassword
                    ? const Color.fromARGB(255, 24, 146, 154).withOpacity(0.5)
                    : Colors.grey.withOpacity(0.5);
              });
            },
          ),
          const SizedBox(height: 10),
          _buildSecurityOption(
            screenWidthSizes:screenWidthSizes *0.9,
            icon: Icons.lock_clock_outlined,
            title: 'Two Factor Authentication',
            trailing: Switch(
              value: _isOtpEnabled,
              onChanged: (value) {
                _updateSettings(value);
              },
              activeTrackColor: _isOtpEnabled
                  ? const Color.fromARGB(255, 24, 146, 154)
                  : Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          _buildSecurityOption(
            screenWidthSizes:screenWidthSizes *0.9,
            icon: Icons.fingerprint,
            title: 'Fingerprint unlock',
            trailing: Switch(
              value: _isFingerPrintEnabled,
              onChanged: (newvalue) {
                _updateFingerprints(newvalue);
              },
              activeTrackColor: _isFingerPrintEnabled
                  ? const Color.fromARGB(255, 24, 146, 154)
                  : Colors.grey,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> twoFactorSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOtpEnabled = prefs.getBool('otp_enabled') ?? false;
    });
  }

  Future<void> _updateSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOtpEnabled = value;
      prefs.setBool('otp_enabled', value);
    });
  }

  Future<void> BiometricSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFingerPrintEnabled = prefs.getBool('Biometric_enable') ?? false;
      print('Loaded fingerprint settings: $_isFingerPrintEnabled');
    });
  }

  Future<void> _updateFingerprints(bool newvalue) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFingerPrintEnabled = newvalue;
      prefs.setBool('Biometric_enable', newvalue);
      print('Updated fingerprint settings: $newvalue');
    });
  }

  Future<bool> _reauthenticateWithEmail(String email, String password) async {
    try {
      final credentials = EmailAuthProvider.credential(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credentials);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('The password is incorrect.');
      } else {
        throw Exception('Unexpected error: $e');
      }
    }
  }

  void _showEmailWithPasswordVerificationBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Enter Password to Continue'),
              content: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(
                      controller: _verifyEmailWithPassword,
                      validator: _passwordValidator,
                      obscureText: _obscureText,
                      toggleVisibility: () => setState(() => _obscureText = !_obscureText),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel', style: TextStyle(fontSize: 20)),
                ),
                _loading
                    ? Center(child: loading())
                    : TextButton(
                  onPressed: () async {
                    try {
                      final password = _verifyEmailWithPassword.text.trim();
                      if (email != null && password.isNotEmpty) {
                        final isReauthenticated = await _reauthenticateWithEmail(email!, password);
                        if (isReauthenticated) {
                          Navigator.of(context).pop();
                          setState(() => _isUserAuthenticated = true);
                          _showOverlayMessage(context, 'Verified');
                          Navigator.push(context, transitionEffect(page: AddFingerprint()));
                        }
                      } else {
                        _showOverlayMessage(context, 'Please enter your password');
                      }
                    } catch (e) {
                      _showOverlayMessage(context, 'Reauthentication failed: $e');
                    } finally {
                      setState(() => _loading = false);
                    }
                  },
                  child: const Text('Continue', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    required bool obscureText,
    VoidCallback? toggleVisibility,
  }) {
    return TextFormField(
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: toggleVisibility != null
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: obscureText ? Colors.grey : const Color.fromARGB(255, 24, 146, 154),
          ),
          onPressed: toggleVisibility,
        )
            : null,
        labelStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 24, 146, 154)),
        ),
      ),
    );
  }

  Widget _buildSecurityOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  required double screenWidthSizes,

  }) {
    return Padding(
      padding:  EdgeInsets.only(left: 24.0),
      child: Container(
        width: screenWidthSizes * 1,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.topLeft,
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, size: 30, color: _editProfileColor),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: _editProfileColor)),
          trailing: trailing,
        ),
      ),
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

  String? _passwordValidator(String? value) {
    return (value == null || value.isEmpty) ? 'Password cannot be empty' : null;
  }
}
