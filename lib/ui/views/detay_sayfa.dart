import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:online_yemek_uygulamasi/data/entity/yemekler.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/detay_sayfa_cubit.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/detay_sayfa_state.dart';
import 'package:online_yemek_uygulamasi/ui/views/sepet_sayfa.dart';

class DetaySayfa extends StatefulWidget {
  final Yemekler yemek;
  const DetaySayfa({required this.yemek, super.key});

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  int adet = 1;

  @override
  void initState() {
    super.initState();
    context.read<DetaySayfaCubit>().siparisAdeti(widget.yemek, "rosemary");
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,//içerisinde bulunan widgetlar dışarı taşabilir
            children: [
              Container(
                height: 300,
                 decoration: BoxDecoration(
                   image: DecorationImage(
                       image: AssetImage("iconlar/detay_arka_plan.png"),
                     fit: BoxFit.cover
                   ),
                   borderRadius: BorderRadius.circular(40)
                 ),
              ),
              Positioned(
                top: 60,
                left: 30,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(CupertinoIcons.back),color: Colors.deepOrange.shade900,iconSize: 30,)
                ),
              ),
              Positioned(
                top: 60,
                right: 30,
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: IconButton(
                        onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SepetSayfa(kullanici_adi: "rosemary"),)).then((value){
                        context.read<DetaySayfaCubit>().siparisAdeti(widget.yemek, "rosemary");
                      });
                    }, icon: Icon(CupertinoIcons.cart),color: Colors.deepOrange.shade900,iconSize: 30,)
                ),
              ),
              Positioned(
                  top: 200,
                  left: 0,
                  right: 0,
                  child: Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${widget.yemek.yemek_resim_adi}",
                    width: 200,
                    height: 200,
                  ),
              ),
            ],
          ),
          const SizedBox(height: 80,),
          Text("${widget.yemek.yemek_adi}",style: TextStyle(color: Colors.deepOrange.shade900,fontSize: 30,fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("₺${widget.yemek.yemek_fiyat}",style: TextStyle(color: Colors.deepOrange.shade400,fontSize: 30,fontWeight: FontWeight.bold),),
                const SizedBox(width: 20,),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: BlocBuilder<DetaySayfaCubit,DetaySayfaState>(
                      builder: (context, state) {
                        int siparisAdeti = state.siparisAdeti;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                  backgroundColor: Colors.deepOrange.shade50,
                                  child: IconButton(
                                    onPressed: () {
                                      context.read<DetaySayfaCubit>().siparisAdetiniDegistir(++siparisAdeti);
                                    },
                                    icon: Icon(CupertinoIcons.plus),
                                  )),
                              Text("${state.siparisAdeti}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              CircleAvatar(
                                  backgroundColor: Colors.deepOrange.shade600,
                                  child: IconButton(
                                      onPressed: () {
                                        if(state.siparisAdeti > 0){
                                          context.read<DetaySayfaCubit>().siparisAdetiniDegistir(-- siparisAdeti);
                                        }
                                      },
                                      icon: Icon(CupertinoIcons.minus))
                              ),
                            ],
                          );
                        }
                        ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<DetaySayfaCubit,DetaySayfaState>(
          builder: (context, state) {
            int siparisAdeti = state.siparisAdeti;
           return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.deepOrange.shade50
                      ),
                      child: Center(child: Text("₺${int.parse(widget.yemek.yemek_fiyat)*state.siparisAdeti}",
                        style: TextStyle(color: Colors.deepOrange.shade900,fontSize: 20,fontWeight: FontWeight.w500),))
                  ),

                ),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                         if(state.siparisAdeti > 0){
                           context.read<DetaySayfaCubit>().sepeteYemekEkle(widget.yemek,state.siparisAdeti.toString(), "rosemary");
                         }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Sepete Ekle", style: TextStyle(fontSize: 20,
                              color: Colors.deepOrange.shade50)),
                          SizedBox(width: 20,),
                          Icon(CupertinoIcons.cart_badge_plus, size: 30,
                              color: Colors.deepOrange.shade50),
                        ],
                      )
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
