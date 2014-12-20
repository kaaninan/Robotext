
/* Program Düzenlemesi

  A- TANIMLAMALAR 
    1- Arduino Uno Pin Tanımlama
    2- Arduino Mega Pin Tanımlama 
    3- Open Sound Control Tanımlama
    4- Processing Tanımlama
    5- Genel Tanımlama
    
  B- OPEN SOUND CONTROL
    1- Gelen Veri
    2- Giden Veri
  
  C- ARDUINO
    1- Arduino'ya Manual Veri Gönderme
    2- Arduino'dan Gelen Veri
  
  D- SETUP
    1- Arduino pinMode()
    2- Serial Başlatma
  
  E- DRAW
    1- Güvenlik Kontrolü

*/


/* Hareket Algoritması
    
    A1- Hareket ve ses sensörlerini kontrol et
    A2- Hareket veya ses algılanırsa
      - Hareket/Zaman ve Ses/Zaman grafiğini başlat
      - Işığı aç
      - Resim çek
      - Resimdeki yüzleri tanı
      - Tanınan yüzleri mevcut listeyle karşılaştır
        -> Eğer tanınan yüz ise durdur
        -> Yüz tanınmadıysa veya yoksa devam et
      
    A3- Alarm çal
    A4- Resim çekildikten sonra grafiği durdur
    A5- Hazır taslağa verileri ekle ve mail at
    
    A6- Sitemi 5sn boyunca çalıştır.
    A7- Süre bitince
      - Kamera ile 3 resim çek
      
    A8- Tüm grafiği ve 4 resmi mail at

*/
