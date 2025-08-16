import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yemek_uygulamasi/data/entity/yemekler.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/begenilenler_sayfa_cubit.dart';
import 'package:online_yemek_uygulamasi/ui/views/begenilenler_sayfa.dart';
import 'package:online_yemek_uygulamasi/ui/views/detay_sayfa.dart';
import 'package:online_yemek_uygulamasi/ui/views/sepet_sayfa.dart';

import '../cubit/anasayfa_state.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  var tfArama = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AnasayfaCubit>().yemekleriListele();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
          child:  AppBar(
            backgroundColor: Colors.deepOrange.shade50,
            automaticallyImplyLeading: false,
            title: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.deepOrange.shade50,
                        child: Icon(Icons.fastfood_sharp,color: Colors.deepOrange.shade900,)

                    ),
                    const SizedBox(width: 10,),
                    Text("Yemek Dükkanı",style: TextStyle(fontSize: 17,color: Color(0xFF3E2723)),),
                  ],
                  
                ),
            actions: [
              PopupMenuButton<String>(itemBuilder: (context) {// :
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem(child: Text("A-Z'ye sırala"),
                      onTap: (){
                      context.read<AnasayfaCubit>().siralamaYapAZ();
                      },
                    ),
                    PopupMenuItem(child: Text("Z-A'ya sırala"),
                        onTap: (){
                         context.read<AnasayfaCubit>().siralamaYapZA();
                        }
                    ),
                    PopupMenuItem(child: Text("Düşük Fiyat-Yüksek Fiyat sırala"),
                        onTap: (){
                         context.read<AnasayfaCubit>().fiyataGoreSiralaDY();
                        }
                    ),
                    PopupMenuItem(child: Text("Yüksek Fiyat- Düşük Fiyat sırala"),
                        onTap: (){
                         context.read<AnasayfaCubit>().fiyataGoreSiralaYD();
                        }
                    )
                  ];
                },
              )
            ],
          ),
        ),
      ),
        body: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white,
          ),
          child: BlocBuilder<AnasayfaCubit, AnasayfaState>(
            builder: (context, state) {
              tfArama.text = state.aramaKelimesi;
              tfArama.selection = TextSelection.fromPosition(TextPosition(offset: tfArama.text.length));
              return Column(
                children: [
                  state.aramaYapiliyorMu
                      ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: tfArama,
                      decoration: InputDecoration(
                        hintText: "Ürün adı yazınız",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            context.read<AnasayfaCubit>().aramaYapiliyorMu(false);
                          },
                          icon: const Icon(CupertinoIcons.clear),
                        ),
                      ),
                      onChanged: (value) {
                        context.read<AnasayfaCubit>().aramaMetniDegisti(value);
                      },
                    ),
                  )
                      : GestureDetector(
                    onTap: () {
                      context.read<AnasayfaCubit>().aramaYapiliyorMu(true);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.search),
                          SizedBox(width: 10),
                          Text("Yemek aramak için tıklayınız.", style: TextStyle(fontSize: 17)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child:(state.gosterilecekListe.isNotEmpty)
                        ? GridView.builder(
                      itemCount: state.gosterilecekListe.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 1.2 / 1.6),
                      itemBuilder: (context, index) {
                        var yemek = state.gosterilecekListe[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetaySayfa(yemek: yemek)));
                            },
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          context.read<AnasayfaCubit>().toggleBegeni(yemek);
                                        },
                                        icon: Image.asset(
                                          "iconlar/heart.png",
                                          color: state.begenilenYemekIdSet.contains(yemek.yemek_id)
                                              ? Colors.red
                                              : Colors.grey,
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_adi}"),
                                    ),
                                    Text(yemek.yemek_adi, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF3E2723))),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("₺${yemek.yemek_fiyat}", style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Color(0xFFD2691E))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                        : const Center(
                      child: Text("Yemek Bulunamadı"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 5,left: 30,right: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BlocBuilder<AnasayfaCubit,AnasayfaState>(
            builder: (context, state) {
              return NavigationBar(
                onDestinationSelected: (seciliNumara){
                  context.read<AnasayfaCubit>().seciliIcon(seciliNumara);
                  if(seciliNumara == 1)
                     Navigator.push(context,MaterialPageRoute(builder: (context) => BegenilenlerSayfa(),)).then((value){
                        context.read<AnasayfaCubit>().yemekleriListele();
                        context.read<AnasayfaCubit>().seciliIcon(0);
                     });
                 else if(seciliNumara == 2){
                   Navigator.push(context,MaterialPageRoute(builder: (context) => SepetSayfa(kullanici_adi: "rosemary"),));
                  }
                },
                selectedIndex: state.seciliIconNumarasi,
                indicatorColor: Colors.deepOrange.shade50,
                backgroundColor: Colors.deepOrange.shade50,
                destinations: [
                  NavigationDestination(icon: Icon(CupertinoIcons.house_alt_fill,color: Colors.deepOrange.shade900,), label: "Anasayfa"),
                  // NavigationDestination'daki kalp ikonunu güncellenmiş hali
                  NavigationDestination(
                    icon: Stack(
                      clipBehavior: Clip.none, // Taşan widget'ın görünür olmasını sağlar
                      children: [
                        Image.asset(
                          "iconlar/heart.png",
                          width: 24,
                          height: 24,
                          color: Colors.deepOrange.shade900,
                        ),
                        // Cubit'ten gelen beğeni sayısını dinle
                        BlocBuilder<AnasayfaCubit, AnasayfaState>(
                          builder: (context, state) {
                            if (state.begeniSayisi > 0) {
                              return Positioned(
                                right: -11, // İkonun sağ üst köşesine konumlandır
                                top: -6,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    "${state.begeniSayisi}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                    label: "Favoriler",
                  ),
                  NavigationDestination(icon: Icon(CupertinoIcons.cart_fill,color: Colors.deepOrange.shade900), label: "Sepet"),
                ],
              );
            },
          ),
        ),
      )
    );
  }
}
