import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passwordmanager/screens/home/settings/profileSettings/profileImage.dart';
import 'package:passwordmanager/services/auth.dart';
import 'package:passwordmanager/sharedFiles/loading.dart';
import 'package:passwordmanager/sharedFiles/logo.dart';
import 'package:passwordmanager/sharedFiles/transitionEffect.dart';
import 'package:passwordmanager/screens/home/manageEmailPasswords.dart';
import 'package:passwordmanager/screens/home/manageBankPassword.dart';
import 'package:passwordmanager/screens/home/manageOtherDetails.dart';
import 'package:passwordmanager/screens/home/socialMediaPassword.dart';
import 'package:passwordmanager/screens/home/viewPassword.dart';
import 'package:passwordmanager/screens/home/settings/settings.dart';
import 'package:passwordmanager/screens/home/cryptoWalletToken.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../sharedFiles/globals.dart' as globals;
import '../home/OverlayMessage.dart';
import '../home/home.dart';
import 'notificationService.dart';

class ViewNotification extends StatefulWidget {
  const ViewNotification({Key? key,}) : super(key: key);

  @override
  State<ViewNotification> createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
  bool _isLoading = false;
  final picker = ImagePicker();
  final Authservices _auth = Authservices();
  bool  showmessageBody =true;
  bool showLoginMessage= true;
  bool changeColor= false;
  bool isMessageViewed = false;
  bool isMessageDeleted= false;
  bool messageCopied= false;
  bool isLoginMessageDeleted= false;
  bool loginMessageCopied= false;
  int _selectedIndex = 2;
 final NotificationService notificationService= NotificationService();
  late int attempt;


  @override
  void initState() {
    super.initState();
    _loadMessageState().then((isDeleted){
      setState(() {
        isMessageDeleted= isDeleted;
      });
    });
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
  // Load the message viewed state from SharedPreferences
  Future<bool> _loadMessageState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isMessageViewed = prefs.getBool('isMessageViewed') ?? false;
      isMessageDeleted =prefs.getBool("isMessageDeleted")?? false;
      isLoginMessageDeleted= prefs.getBool("isLoginMessageDeleted")?? false;
    });
    return prefs.getBool('isMessageDeleted')?? false;
  }
  AssetImage defaultImage= const AssetImage("assets/litmac.png");
  // Save the message viewed state to SharedPreferences
  void _saveMessageState(bool isDeleted, bool isloginDeleted) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMessageViewed', isMessageViewed);
    prefs.setBool('isMessageDeleted', isDeleted);
    prefs.setBool('isLoginMessageDeleted', isloginDeleted);
  }
  //function to deleted message
  void _markAsDeleted(){
    setState(() {
      isMessageDeleted =true;
      _saveMessageState(isMessageDeleted, isLoginMessageDeleted);
    });
    _showOverlayMessage(context, 'Deleted');
  }
  void _markAsLoginMessageDeleted() {
    setState(() {
      isLoginMessageDeleted = true;
      _saveMessageState(isMessageDeleted, isLoginMessageDeleted);
    });
    _showOverlayMessage(context, 'Login message deleted');
  }
  // function when message is viewd
  void _makeAsViewed(){
    setState(() {
      isMessageViewed= true;
      _saveMessageState(isMessageViewed,true);
    });
  }

  //function when message is copied
  void _markAsCopied(){
    _showOverlayMessage(context, 'Notification copied');
    setState(() {
      loginMessageCopied=true;
      _saveMessageState(loginMessageCopied,true);
    });
  }
  Future <Map<String, dynamic>> registerNotisfication(BuildContext context) async{
    final FirebaseAuth _auth= FirebaseAuth.instance;
    final FirebaseFirestore getMessage= FirebaseFirestore.instance;
    final currentUser= _auth.currentUser;
    if(currentUser==null){
      print('no user currently');
      return {'notification' : 'unknown'};
    }

    final userId = currentUser.uid;
    final userDocuRef= getMessage.collection('users').doc(userId);
    final DocumentSnapshot snapshot= await userDocuRef.get();
    if(!snapshot.exists){
      print("no name avaiable");
      return {"notification": "unknown"};
    }
    final Map<String, dynamic> userNotification= snapshot.data() as Map<String, dynamic>;
    return {
      "notification": userNotification['notification'] ?? 'unknown',
      "First name": userNotification['First name'] ?? 'unknown',
      "profileImageUrl": userNotification['profileImageUrl'] ?? const Logo(),

    };
  }



  @override
  Widget build(BuildContext context) {
    IconData iconshow= showmessageBody ? Icons.expand_less: Icons.expand_more;
    IconData iconLogin = showLoginMessage? Icons.expand_less : Icons.expand_more;
    attempt= notificationService.getLoginAttempts();

    return _isLoading
        ? const loading()
        : DefaultTabController(
      initialIndex: _selectedIndex,
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 24, 146, 154),
            actions: [
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, size: 40, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              const Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  iconColor: Colors.white,
                  iconSize: 40,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context, transitionEffect(page: Setting()),
                          );
                        },
                        child: const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 24, 146, 154),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 250,
                color: Color.fromARGB(255, 24, 146, 154),
                child: const DrawerHeader(
                  margin: EdgeInsets.zero,
                  child: ProfileImage(),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Manage Emails'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageEmailPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Manage Bank Password'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageBankPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Manage Social Media'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageSocialMediaPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.wallet),
                      title: const Text('Manage Crypto Wallet'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: ManageCryptoPassword()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.details),
                      title: const Text('Other Details'),
                      onTap: () {
                        Navigator.push(
                          context, transitionEffect(page: manageOtherDetails()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    try {
                      await _auth.signOut();
                      Navigator.of(context).pushReplacementNamed('/sign_in');
                    } catch (e) {
                      print('Error signing out: $e');
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 24, 146, 154)),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body:  SingleChildScrollView(
          padding: const EdgeInsets.only(right: 16.0, left: 2),
          child: FutureBuilder<Map<String,dynamic>>(
            future: registerNotisfication(context),
            builder: (context,snapshot){
              if(snapshot.connectionState== ConnectionState.waiting){
                return const Center(child: loading());
              }
              if(snapshot.hasError){
                return Center(child: Text('Error ${snapshot.error}'),);
              }
              final userData= snapshot.data ??{"notification": "no notification", "First name": "no first name available ","profileImageUrl": "${AssetImage("assets/litmac.png")}"};
              String notificationText = userData['notification'] ?? 'No notification available';
              String userName= userData['First name']?? 'no First name avaliable';
              String userImage= userData['profileImageUrl'] ?? "${Icons.person}";


            return Column(
              children: [


                Column(
                  children:[
                    if(!isMessageDeleted)...[
                    IconButton(
                      onPressed: (){
                        setState(() {
                          showmessageBody =!showmessageBody;
                          if(showmessageBody){
                            _makeAsViewed();
                          }
                        });
                      },
                      icon: Row(
                        children: [
                          IconButton
                            (
                              onPressed: (){
                              },
                              icon:   Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(width: 4, color:const Color.fromARGB(255, 24, 146, 154), )
                                ),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:(userImage.isNotEmpty && Uri.tryParse(userImage)?.hasAbsolutePath==true)
                                      ? NetworkImage(userImage)
                                      :const AssetImage('assest/defaultImageProfile.jpg') as ImageProvider,
                                ),
                              ),
                          ),
                          Text("Registration: Welcome $userName",style:
                           TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.bold,
                              color: isMessageViewed
                                ? const Color(0xFF6E6E6E)
                                  :Colors.black,
                            ),),
                          const Spacer(),
                          Icon(iconshow, color: const Color.fromARGB(255, 24, 146, 154),size: 40,),
                        ],
                      ),
                    ),

                     if(showmessageBody)...[

                     Padding(
                       padding: const EdgeInsets.only(left: 80.0),
                       child: Text(notificationText,
                         style:const TextStyle(
                           fontSize: 16,
                           fontFamily: 'Poppins-Regular',
                           fontWeight: FontWeight.w500,
                         ),),
                     ),

                  //button for delete and copied
                    Row(
                      children: [
                        Spacer(),
                        IconButton(
                            onPressed: (){_markAsDeleted();},
                            icon: const Icon(Icons.delete, color:Color.fromARGB(255, 24, 146, 154) ,)),
                     IconButton(
                         onPressed: (){_markAsCopied();},
                         icon: Icon(Icons.copy, color: Color.fromARGB(255, 24, 146, 154),)),
                      ],
                    ),
                  ],
                  ],
                  for(String message in (globals.longinSuccessful))
                   if(!isLoginMessageDeleted)...[
                    IconButton(
                      onPressed: (){
                        setState(() {
                          showLoginMessage =!showLoginMessage;
                          if(showLoginMessage){
                            _makeAsViewed();
                          }
                        });
                      },
                      icon: Row(
                        children: [
                          IconButton
                            (
                            onPressed: (){},
                            icon:   Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(width: 4, color:Color.fromARGB(255, 24, 146, 154), )
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: (userImage.isNotEmpty && Uri.tryParse(userImage)?.hasAbsolutePath==true)
                                    ? NetworkImage(userImage)
                                    :const AssetImage('assest/defaultImageProfile.jpg') as ImageProvider,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Text(message,style:
                            TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins-Regular',
                              fontWeight: FontWeight.bold,
                              color: isMessageViewed
                                  ? Color(0xFF6E6E6E)
                                  :Colors.black,
                            ),),
                          ),
                          Spacer(),
                          Icon(iconshow, color: const Color.fromARGB(255, 24, 146, 154),size: 40,),
                        ],
                      ),
                    ),
                    if(showLoginMessage)...[

                      Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: Text(notificationText,
                          style:const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w500,
                          ),),
                      ),
                    Row(
                      children: [
                        Spacer(),
                        IconButton(
                            onPressed: (){_markAsDeleted();},
                            icon: const Icon(Icons.delete, color:Color.fromARGB(255, 24, 146, 154) ,)),
                        IconButton(
                            onPressed: (){_markAsCopied();},
                            icon: Icon(Icons.copy, color: Color.fromARGB(255, 24, 146, 154),)),
                      ],
                    ),
              ],
              ],
                  ],
                ),




              ],
            );
  },
          ),
        ),


        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 24, 146, 154),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.lock, size: 30.0),
                label: 'Passwords',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30.0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notification_add, size: 30.0),
                label: 'Notifications',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.transparent,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Widget page;
      switch (index) {
        case 0:
          page = ViewPassword();
          break;
        case 1:
          page = Home();
          break;
        case 2:
          page = ViewNotification();
          break;
        default:
          page = Home();
      }
      Navigator.push(
        context,
        transitionEffect(page: page),
      );
    });
  }


}
