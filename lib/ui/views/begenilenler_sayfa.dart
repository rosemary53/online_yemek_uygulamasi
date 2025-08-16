import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yemek_uygulamasi/data/entity/yemekler.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/begenilenler_sayfa_cubit.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/begeniler_sayfa_state.dart';
import 'package:online_yemek_uygulamasi/ui/views/anasayfa.dart';

import '../cubit/anasayfa_cubit.dart';

class BegenilenlerSayfa extends StatefulWidget {
  const BegenilenlerSayfa({super.key});

  @override
  State<BegenilenlerSayfa> createState() => _BegenilenlerSayfaState();
}

class _BegenilenlerSayfaState extends State<BegenilenlerSayfa> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<BegenilenlerSayfaCubit>().begenilenYemekListele();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade200,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade200,
        title:Text("Favoriler",style: TextStyle(color: Colors.brown.shade500,fontWeight: FontWeight.w500),),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(CupertinoIcons.chevron_back)),
      ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Expanded(
                child: BlocBuilder<BegenilenlerSayfaCubit, BegenilerSayfaState>(
                  builder: (context, state) {
                    if (state.yemekListe.isNotEmpty) {
                      return ListView.builder(
                        itemCount: state.yemekListe.length,
                        itemBuilder: (context, index) {
                          var begenilenYemek = state.yemekListe[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: SizedBox(
                              height: 120,
                              child: Card(
                                color: Colors.white,
                                elevation: 4, // Card'a hafif bir gölge ekler
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 100, // Resim için sabit bir genişlik
                                        height: 100, // Resim için sabit bir yükseklik
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrange.shade50,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: Image.network(
                                                "http://kasimadalan.pe.hu/yemekler/resimler/${begenilenYemek.yemek_resim_adi}",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const Positioned(
                                              left: 6,
                                              top: 6,
                                              child: Icon(
                                                CupertinoIcons.heart_circle_fill,
                                                color: Colors.red,
                                                size: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16), // Resim ile metin arasına boşluk
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            begenilenYemek.yemek_adi,
                                            style: TextStyle(
                                              color: Colors.brown.shade500,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "₺${begenilenYemek.yemek_fiyat}",
                                            style: TextStyle(
                                              color: Colors.deepOrange.shade900,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.read<BegenilenlerSayfaCubit>().begenilenleriKaldir(begenilenYemek.yemek_id);
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.clear_fill,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "Henüz beğenilen yemek yok.",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        )    );
  }
}
