import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_innoventure/feature/all_user/all_user.dart';
import 'package:test_innoventure/feature/auth/presentation/bloc/auth_cubit.dart';
import 'package:test_innoventure/feature/auth/presentation/bloc/auth_state.dart';
import 'package:test_innoventure/feature/login/presentation/pages/login_page.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => HomeCubit()..fetchItems(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Home',style: TextStyle(color: Colors.white),),
//           centerTitle: true,
//           elevation: 2,
//           backgroundColor: Colors.blue,
//           actions: [
//             IconButton(
//               onPressed: () async {
//                 AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
//                 authCubit.logout();
//               },
//               icon: const Icon(Icons.logout,color: Colors.white,),
//             ),
//           ],
//         ),
//         body: BlocListener<AuthCubit, AuthState>(
//           listener: (context, state) {
//             if (state is AuthUnauthenticated) {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginPage()),
//                 (route) => false,
//               );
//             }
//           },
//           child: BlocListener<HomeCubit, HomeState>(
//             listener: (context, state) {
//               if (state is HomeLogout) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => BlocProvider(
//                       create: (context) =>
//                           LoginCubit(firebaseAuth: FirebaseAuth.instance),
//                       child: LoginPage(),
//                     ),
//                   ),
//                 );
//               }
//             },
//             child: BlocBuilder<HomeCubit, HomeState>(
//               builder: (context, state) {
//                 if (state is HomeLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is HomeLoaded) {
//                   return ListView.builder(
//                     itemCount: state.items.length,
//                     itemBuilder: (context, index) {
//                       final item = state.items[index];
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Card(
//                           color: const Color.fromRGBO(255, 255, 255, 1.0),
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ListTile(
//                               title: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(item.name.toString()),
//                                   Text(item.email ?? "")
//                                 ],
//                               ),
//                               trailing: const Icon(Icons.arrow_forward_ios_outlined,color: Colors.blue,),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         DetailPage(item: item),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 } else if (state is HomeError) {
//                   return Center(child: Text(state.error));
//                 } else if (state is HomeLogout) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 return const Center(child: Text('No items'));
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserAllList()));
                    },
                    child: const Icon(Icons.group)),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () async {
                    _showLogoutDialog(context);
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            }
          },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        BorderSide.none, // Removes the border for a softer look
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                ),
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Age',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        BorderSide.none, // Removes the border for a softer look
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                ),
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: addUser,
                child: const Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addUser() async {
    String name = _nameController.text;
    String age = _ageController.text;

    if (name.isEmpty || age.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid name and age.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _nameController.clear();
      _ageController.clear();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const UserAllList()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add user: $e")),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(context); // Execute the logout logic
              },
              child: const Text('Yes, Log Out'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async{
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    authCubit.logout();
  }
}
