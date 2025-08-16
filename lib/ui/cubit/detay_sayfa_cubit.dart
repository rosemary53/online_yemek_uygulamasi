import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yemek_uygulamasi/data/entity/sepet_yemekler.dart';
import 'package:online_yemek_uygulamasi/data/repository/yemek_repo.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/detay_sayfa_state.dart';

import '../../data/entity/yemekler.dart';

class DetaySayfaCubit extends Cubit<DetaySayfaState>{

  DetaySayfaCubit():super(DetaySayfaState());

  var yRepo = YemekRepo();

  Future <void> sepeteYemekEkle(Yemekler yemekNesnesi,String yeniSiparisAdeti,String kullanici_adi) async {
    //State içinde bulunan değişkenler listeler burada sadece emit ile teiklenir güncellenir
     SepetYemekler? mevcutSepetYemek;
     //elimizde guncel var olan sepet yemek listesini aldık
     var guncelSepetListesi = await yRepo.sepetYemekListele(kullanici_adi);
     //listede olan elemanları sepetYemeke atadık
     for(var sepetYemek in guncelSepetListesi){
       //sepette bulunan yemeğin adı ile eklenmek istenenin adı aynıysa bu ürün zaten sepette var demektir.
        if(sepetYemek.yemek_adi == yemekNesnesi.yemek_adi){ // sepette bu üründen var
          mevcutSepetYemek = sepetYemek;
          print("Bu ürün zaten var ");
          break;
        }
     }
     if(mevcutSepetYemek != null){//sepette eklenmek istenen nesne zaten varsa geçmiş adet ile yeni adet toplanıp yeni sipariş adeti oluşturuldu
       int gecmisSiparisAdeti = int.parse(mevcutSepetYemek.yemek_siparis_adet);
       int ekSiparisAdeti = int.parse(yeniSiparisAdeti);
       int toplamSiparisAdeti = gecmisSiparisAdeti + ekSiparisAdeti;
       print("Eski siparis adeti ile ekSiparis adeti toplandı.");
       //Bizim webservis üzerinde güncelleme fonku olmadıgı için önce silip sonra tekrar toplam siparis adedi ile sepete ekledim
       await yRepo.sepetYemekSil(mevcutSepetYemek.sepet_yemek_id, kullanici_adi);
       await yRepo.sepeteYemekEkle(yemekNesnesi,toplamSiparisAdeti.toString(), kullanici_adi);
     }
     else{
       print("Bu ürün sepette yok o yüzden direkt eklendi");
       //eğer yeni ürün sepette yoksa direkt ekledim
       await yRepo.sepeteYemekEkle(yemekNesnesi,yeniSiparisAdeti, kullanici_adi);
     }
     // en sonunda yapılan işlemlerden sonra sepetYemek Listesi yenilendi
     var sonSepetListesi = await yRepo.sepetYemekListele(kullanici_adi);
     //state de bulunan listede guncellendi ve detaysayfada kullanılmaya hazırlandı
     emit(state.copyWith(sepetYemekler: sonSepetListesi));
  }

  Future<void> siparisAdeti(Yemekler yemek,kullanici_adi) async{
    var sepetUrunler = await yRepo.sepetYemekListele(kullanici_adi);
    int? guncelSiparisAdedi;
    for(var sepetYemek in sepetUrunler){
      if(yemek.yemek_adi == sepetYemek.yemek_adi){
        print("Bu ürün var adedi : ${sepetYemek.yemek_siparis_adet} ");
        guncelSiparisAdedi = int.parse(sepetYemek.yemek_siparis_adet);
        break;
      }
    }
    if(guncelSiparisAdedi != null){
      print("Siparis adedi : $guncelSiparisAdedi");
      emit(state.copyWith(siparisAdeti: guncelSiparisAdedi));
    }
    else{
      emit(state.copyWith(siparisAdeti: 0));
    }
  }

  Future<void> siparisAdetiniDegistir(int siparisAdeti) async{
    emit(state.copyWith(siparisAdeti: siparisAdeti));
  }

}