import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yemek_uygulamasi/data/entity/sepet_yemekler.dart';
import 'package:online_yemek_uygulamasi/data/entity/yemekler.dart';
import 'package:online_yemek_uygulamasi/data/repository/yemek_repo.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/sepet_sayfa_state.dart';

class SepetSayfaCubit extends Cubit<SepetSayfaState>{

  SepetSayfaCubit():super(SepetSayfaState());

  var yRepo = YemekRepo();

  // Cubit içinde doğru kullanım
  Future<void> sepetYemekListele(String kullanici_adi) async{
    // Repodan listeyi al
    var sepetYemekListe = await yRepo.sepetYemekListele(kullanici_adi);
    sepetYemekListe.sort((ilkSepetYemek, ikinciSepetYemek) => ilkSepetYemek.yemek_adi.compareTo(ikinciSepetYemek.yemek_adi));//ürünleri sıralayıp ekrana öyle getiriyorum
    emit(state.copyWith(sepetYemekListe: sepetYemekListe));
  }

  Future <void>  sepetYemekSil(String sepet_yemek_id,String kullanici_adi) async{
    await yRepo.sepetYemekSil(sepet_yemek_id, kullanici_adi);
    await sepetYemekListele(kullanici_adi);//cubitteki fonksiyonu çağır
  }
  Future sepetSiparisAdediniDegistir(SepetYemekler sepetYemek,int siparisAdedi,String kullanici_adi) async{//Sepette var pşan bir ürün
    await yRepo.sepetYemekSil(sepetYemek.sepet_yemek_id, kullanici_adi);
    if(siparisAdedi > 0){
      Yemekler yemek = Yemekler(yemek_id: "0", yemek_adi: sepetYemek.yemek_adi, yemek_resim_adi:sepetYemek.yemek_resim_adi, yemek_fiyat: sepetYemek.yemek_fiyat);
      await yRepo.sepeteYemekEkle(yemek, siparisAdedi.toString(), kullanici_adi);
    }
    await sepetYemekListele(kullanici_adi);
  }
}