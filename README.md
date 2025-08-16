# Online Yemek Uygulaması
 Bu uygulamadaki genel amacım bir yemek uygulamasındaki temel işlevler nelerdir onları öğrenmek ve uygulamaya geçirmekti.
 Başlangıç düzeyinde olduğu için  uygulamada kayıt olma ve en sonunda sepet onayla gibi kısımlara yer vermedim.

# Uygulamanın Genel Özellikleri

 1) API ile veriler webservisden JSON formatında çekildi . Flutterda Dio kütüphanesi sayesinde veriler üzerinde işlemler gerçekleşti.
 2) Veritabanının genel CRUD işlemleri için repository oluşturuldu .
 3) Uygulama mimarisi esas alınarak sayfalar arasında katmanlı ve modüler bir yapı oluşturuldu. Bloc Pattern
 4) Veri ile ilgili işlemler data,Sayfa ile ilgili işlemler ui kısmında kategorilendirildi.
 5) Her sayfaya ait cubit ve state oluşturuldu.

# Kullanıcıya sağlanan olanaklar

1) Kullanıcı istediği yemeği aratabilir.
2) Yemeği beğenilere ekleyip kaldırabilir.Tüm beğendiği yemekleri favoriler sayfasında görüntülüyebilir veya bu sayfada beğenilerden kaldırabilir.
3) Kullanıcı alfabetik,fiyata göre sıralama yapabilir.
4) Kullanıcı yemek hakkında detay alabilir.
5) Sepete istenilen adette yemek eklenebilir.
6) Siparis adedi güncellenebilir.
7) Sepet sayfasında sepete eklediği ürünleri görüntüleyebilir .Aynı zamanda yine yemeğe ait siparis adedi güncellenebilir .Yemek sepetten silinebilir.
8) Sepette toplam tutarı görüntüleyebilir.

# Kullanılan  Teknolojiler
  Dil : Dart
  Framework : Flutter
  Paketler :   flutter_bloc,dio,path,sqflite
