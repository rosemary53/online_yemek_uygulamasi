import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yemek_uygulamasi/data/entity/yemekler.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/begeniler_sayfa_state.dart';

import '../../data/repository/begenilen_yemek_repo.dart';
import '../../sqlite/veritabani_yardimcisi.dart';

class BegenilenlerSayfaCubit extends Cubit<BegenilerSayfaState>{

  BegenilenlerSayfaCubit():super(BegenilerSayfaState());

  var byRepo = BegenilenYemekRepo();

  Future<void> begenilenYemekListele() async {
    var begenilenYemekListe = await byRepo.begenilenYemekListele();
    emit(state.copyWith(
        yemekListe: begenilenYemekListe
    ));
  }

  Future<void> begenilenleriKaldir(String yemek_id) async {
    await byRepo.begenilenleriKaldir(yemek_id);
    await begenilenYemekListele();
  }
}