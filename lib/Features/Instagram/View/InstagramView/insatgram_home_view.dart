// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../Core/Utils/Functions/animated_navigation.dart';
// import '../../../../Core/Widgets/loading_widget.dart';
// import '../../../Auth/View/loginView/login_view.dart';
// import '../../../Auth/ViewModel/cubit/auth_cubit.dart';

// class InstagramHomeView extends StatelessWidget {
//   const InstagramHomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state is SucceededAuthState) {
//           AnimatedNavigation()
//               .navigate(widget: const LogInView(), context: context);
//         }
//       },
//       builder: (context, state) {
//         if (state is LoadingAuthState) {
//           return const LoadingWidget();
//         }
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Home Page'),
//             leading: IconButton(
//               onPressed: () {
//                 BlocProvider.of<AuthCubit>(context).logOut();
//               },
//               icon: const Icon(Icons.logout),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
