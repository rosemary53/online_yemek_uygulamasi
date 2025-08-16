import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yemek_uygulamasi/data/entity/sepet_yemekler.dart';
import 'package:online_yemek_uygulamasi/ui/views/anasayfa.dart';

import '../cubit/sepet_sayfa_cubit.dart';
import '../cubit/sepet_sayfa_state.dart';

class SepetSayfa extends StatefulWidget {
  String kullanici_adi;
  SepetSayfa({required this.kullanici_adi});

  @override
  State<SepetSayfa> createState() => _SepetSayfaState();
}

class _SepetSayfaState extends State<SepetSayfa> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Bu sayfa açıldığı anda sepette bulunan yemekler listelenecek
    context.read<SepetSayfaCubit>().sepetYemekListele(widget.kullanici_adi);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
         children: [
           Padding(
             padding: const EdgeInsets.only(top: 40,left: 30),
             child: Row(
               children: [
                 Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10),
                       border: Border.all(
                         color: Colors.black12
                       )
                     ),
                     child: IconButton(onPressed: (){
                       Navigator.pop(context);
                     }, icon: Icon(CupertinoIcons.back,size: 30,color: Colors.deepOrange.shade900,))
                 ),
                 const SizedBox(width: 90,),
                 Text("Sepet",style: TextStyle(color: Colors.deepOrange.shade900,fontSize: 25,fontWeight: FontWeight.w400),)
               ],
             ),
           ),
           Expanded(
               child:BlocBuilder<SepetSayfaCubit,SepetSayfaState>(
                   builder: (context, state) {
                     if(state.sepetYemekListe.isNotEmpty){
                       return ListView.builder(
                           itemCount: state.sepetYemekListe.length ,
                           itemBuilder: (context, index) {
                             var sepetYemek = state.sepetYemekListe[index];
                             int siparisAdedi = int.parse(sepetYemek.yemek_siparis_adet);
                             return Padding(
                               padding: const EdgeInsets.only(left: 40,right: 40,bottom: 30),
                               child: Column(
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Row(
                                         children: [
                                           Icon(CupertinoIcons.bag,color: Colors.deepOrange.shade900,size: 25,),
                                           SizedBox(width: 10,),
                                           Text("${sepetYemek.yemek_adi.split(" ")[0]}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                         ],
                                       ),
                                       CircleAvatar(
                                         backgroundColor: Colors.deepOrange.shade50,
                                         child: IconButton(onPressed: (){
                                           context.read<SepetSayfaCubit>().sepetYemekSil(sepetYemek.sepet_yemek_id, "rosemary");
                                         }, icon: Icon(CupertinoIcons.delete,color: Colors.deepOrange.shade900,)),
                                       ),
                                     ],
                                   ),
                                   Divider(),
                                   Row(
                                     children: [
                                       Container(
                                         child: Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${sepetYemek.yemek_resim_adi}"),
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(20),
                                           color: Colors.deepOrange.shade50
                                         ),
                                         width: 100,
                                       ),
                                       const SizedBox(width: 20,),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                         children: [
                                           Text("${sepetYemek.yemek_adi}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.deepOrange.shade900),),
                                           Text("Birim Fiyat : ₺ ${sepetYemek.yemek_fiyat}"),
                                           Text("₺${int.parse(sepetYemek.yemek_fiyat)*int.parse(sepetYemek.yemek_siparis_adet)}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                         ],
                                       ),
                                       Spacer(),
                                       Column(
                                         mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                                         children: [
                                           Container(
                                             child: IconButton(//Bloc kullanılrısa setState kullanımı gerksiz olur
                                                 onPressed: (){
                                                   int siparisAdedi = int.parse(sepetYemek.yemek_siparis_adet);
                                                   int guncelAdet = siparisAdedi + 1;
                                                   context.read<SepetSayfaCubit>().sepetSiparisAdediniDegistir(sepetYemek,guncelAdet, "rosemary");
                                                 },
                                                 icon: Icon(CupertinoIcons.plus,size: 15,)),
                                             decoration: BoxDecoration(
                                               color: Colors.deepOrange.shade50,
                                               borderRadius: BorderRadius.circular(12)
                                             ),
                                             height: 30,
                                           ),
                                           Text("${sepetYemek.yemek_siparis_adet}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                                           Container(
                                             child: IconButton(
                                                 onPressed: (){
                                                   int siparisAdedi = int.parse(sepetYemek.yemek_siparis_adet);
                                                   int guncelAdet = siparisAdedi - 1;
                                                   context.read<SepetSayfaCubit>().sepetSiparisAdediniDegistir(sepetYemek,guncelAdet, "rosemary");
                                                 },
                                                 icon: Icon(CupertinoIcons.minus,size: 15,)),
                                             decoration: BoxDecoration(
                                                 color: Colors.deepOrange.shade50,
                                                 borderRadius: BorderRadius.circular(12)
                                             ),
                                             height: 30,
                                           ),
                                         ],
                                       )
                                     ],
                                   )
                                 ],
                               ),
                             );
                           },
                       );
                     }
                     else{
                       return Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             SizedBox(
                                 child: Image.asset("resimler/empty_cart.png"),
                                 width: 200,
                                 height: 200,
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("Sepetin boş.",style: TextStyle(color: Colors.deepOrange.shade300,fontSize: 17),),
                                 Container(
                                   child: TextButton(
                                       onPressed: (){
                                         Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa(),));
                                       },
                                       child: Text("Şimdi ürün ekle.",style: TextStyle(color: Colors.deepOrange.shade700,fontSize: 17),)),
                                   decoration: BoxDecoration(
                                     color: Colors.deepOrange.shade50,
                                     borderRadius: BorderRadius.circular(30)
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       );
                     }
                   },
               )
           ),
         ],
       ),

      bottomNavigationBar: BlocBuilder<SepetSayfaCubit,SepetSayfaState>(
        builder: (context, state) {
          if(state.sepetYemekListe.isNotEmpty) {
            var toplamTutar = 0;
            for(var yemek in state.sepetYemekListe){
              toplamTutar = toplamTutar + int.parse(yemek.yemek_fiyat)*int.parse(yemek.yemek_siparis_adet);
            }
          return SizedBox(
            height: 90, // bottomNavigationBar için sabit bir yükseklik
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Toplam Tutar",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "₺ ${toplamTutar}", // Dinamik toplam fiyat
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    // Butona ekran genişliğinin %40'ı kadar alan ver
                    child: ElevatedButton(
                      onPressed: () {
                        // Sipariş ver
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Sepeti Onayla",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
          else{
            return const SizedBox.shrink(); // Sepet boşken hiçbir şey göstermiyoruz.Burada widget yokmuş gibi davranır.
          }
      }
      ),
    );
  }
}
