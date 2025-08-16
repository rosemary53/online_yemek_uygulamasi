import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/begenilenler_sayfa_cubit.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/detay_sayfa_cubit.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/sepet_sayfa_cubit.dart';
import 'package:online_yemek_uygulamasi/ui/views/anasayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AnasayfaCubit()),
        BlocProvider(create: (_) => BegenilenlerSayfaCubit()),
        BlocProvider(create: (context) => DetaySayfaCubit()),
        BlocProvider(create: (context) => SepetSayfaCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Anasayfa(),
      ),
    );
  }
}

