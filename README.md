# YemekSiparisi_VTYS_Proje



# Çevrimiçi Yemek Sipariş Platformu - VTYS Dönem Projesi

Bu proje, Veritabanı Yönetim Sistemleri dersi kapsamında 3. Normal Form (3NF) kurallarına uygun olarak tasarlanmış bir çevrimiçi yemek sipariş veritabanıdır.

## Sistemin İş Kuralları ve "Askıda Yemek" Modülü
* **Temel Yapı:** Sistem; Müşteriler, Restoranlar, Kuryeler, Ürünler ve Siparişler olmak üzere birbirine bağlı kurumsal bir mimaride tasarlanmıştır. Veri bütünlüğünü korumak için fiziksel silme işlemi yapılmaz, `IsActive` kolonu ile veriler pasife çekilir (Soft Delete).
* **Askıda Yemek Havuzu:** Hayırsever müşteriler, kimliklerini gizli tutarak (veya açıkça) havuza bakiye bağışı yapabilirler.
* **İhtiyaç Sahibi Doğrulaması:** Sadece sistem yöneticisi (Admin) tarafından `AskidaBasvurulari` tablosu üzerinden onaylanmış ve doğrulanmış müşteriler havuzdaki bakiyeyi kullanarak ücretsiz sipariş verebilir.
* **Otomasyon (Trigger):** Sipariş durumu "Teslim Edildi" olduğunda restoranın bakiyesi otomatik güncellenir. Eğer ödeme yöntemi "Askıda Bakiye" ise ve müşteri yetkisizse sistem (Trigger) hata fırlatarak işlemi iptal eder.

## Yapay Zeka (AI) Kullanım Beyanı
Bu projenin geliştirme sürecinde, veritabanı mühendisliği standartlarına uygunluğu denetlemek amacıyla yapay zeka asistanından destek alınmıştır.
* **Süreç:** M:N (Çoka çok) ilişkilerin 3NF'ye uygun olarak köprü tablolarla (Sipariş Detayları) çözülmesi kararlaştırılmış, yazılan DDL ve DML kodlarındaki syntax (sözdizimi) hataları AI ile tartışarak giderilmiştir. 
* **Mock Data Üretimi:** Sistemin performansını test etmek için gereken 100 adet sahte sipariş, ödeme ve değerlendirme verisi, manuel yazım yükünü hafifletmek adına T-SQL `WHILE` döngüsü kullanılarak üretilmiştir. Projedeki tüm kodlar satır satır incelenmiş ve sistem mantığı tamamen anlaşılarak projeye dahil edilmiştir.
