# 📊 Yüksek Dereceli Momentlere Dayalı Portföy Optimizasyonu  
## Polinom Hedef Programlama (PGP) ile MVSK Modeli

---

## 📖 Proje Hakkında

Bu çalışmada klasik **Markowitz Ortalama–Varyans (MV)** modeline alternatif olarak, yüksek dereceli momentleri içeren **Ortalama–Varyans–Çarpıklık–Basıklık (MVSK)** portföy optimizasyon modeli ele alınmıştır.

Klasik MV modeli yalnızca ortalama ve varyansı dikkate alırken, bu çalışmada:

- ✅ Ortalama (Getiri) maksimize edilmiştir  
- ✅ Varyans (Risk) minimize edilmiştir  
- ✅ Çarpıklık maksimize edilmiştir  
- ✅ Basıklık minimize edilmiştir  

Bu çoklu ve birbiriyle çelişen hedefler **Polinom Hedef Programlama (PGP)** yöntemi kullanılarak tek bir amaç fonksiyonunda birleştirilmiştir.

---

## 📊 Veri Seti

Bu çalışmada BIST-30 endeksinde yer alan aşağıdaki üç hisse senedi kullanılmıştır:

- ARÇELİK  
- AKBANK  
- TÜRK HAVA YOLLARI (THY)  

📅 Veri Aralığı: 02.01.2023 – 29.12.2023  
📈 Günlük logaritmik getiriler kullanılmıştır.  
📌 Toplam 248 gözlem bulunmaktadır.

Analizde günlük logaritmik getiriler kullanılmıştır.

---

## 🧠 Kullanılan Modeller

### 1️⃣ Ortalama–Varyans (MV) Modeli

Getiriyi maksimize ederken riski minimize etmeyi amaçlayan klasik portföy optimizasyon yaklaşımıdır.

---

### 2️⃣ Ortalama–Varyans–Çarpıklık–Basıklık (MVSK) Modeli

Portföyün ilk dört momenti dikkate alınmıştır:

- Ortalama
- Varyans
- Çarpıklık
- Basıklık

Bu model, finansal getirilerin normal dağılmadığı durumlarda daha kapsamlı bir analiz sağlar.

---

### 3️⃣ Polinom Hedef Programlama (PGP)

Çok kriterli optimizasyon problemlerinde hedef sapmalarını minimize ederek yatırımcı tercihlerine uygun portföy bileşimi oluşturur. Bu yöntem doğrusal olmayan bir optimizasyon yaklaşımıdır.

---

## ⚙️ Kullanılan Teknolojiler

- R Programlama Dili  
- RStudio  
- Finansal zaman serisi analizi  
- Çok kriterli optimizasyon teknikleri  

---

## 📈 Elde Edilen Portföy Modelleri

Çalışma sonucunda 6 farklı portföy modeli oluşturulmuştur:

1. Maksimum Ortalama Modeli  
2. Minimum Varyans Modeli  
3. Maksimum Çarpıklık Modeli  
4. Minimum Basıklık Modeli  
5. MV Modeli  
6. MVSK Modeli  

Her model için:

- Optimal ağırlık değerleri  
- İlk dört moment değerleri  
- Ortalama–varyans dağılım grafiği  

rapor içerisinde detaylı olarak sunulmuştur.

---

## 📊 Temel Bulgular

- Yüksek dereceli momentlerin portföy dağılımı üzerinde önemli etkileri gözlemlenmiştir.  
- Polinom Hedef Programlama yöntemi çoklu hedefleri etkin biçimde birleştirmiştir.  
- MVSK modeli, klasik MV modeline kıyasla daha kapsamlı bir risk-getiri analizi sunmaktadır.  
- Yatırımcı tercih katsayıları portföy bileşimini doğrudan etkilemektedir.

---

## 📂 Depo İçeriği

- Veri/ → Hisse senedi veri seti
- Kod/ → R kodları
- Rapor/ → Lisans tez raporu (PDF)
- Poster/ → Akademik proje posteri


---

## 🚀 Nasıl Çalıştırılır?

1. R veya RStudio açın  
2. Gerekli paketleri yükleyin  
3. `Kod.R` dosyasını çalıştırın  
4. Sonuç tabloları ve grafikler otomatik olarak üretilecektir  

---

## 📌 Akademik Bağlam

Bu çalışma, Eskişehir Teknik Üniversitesi İstatistik Bölümü lisans tezi kapsamında hazırlanmıştır (2024).

---

## 📚 Kaynakça

Markowitz, H. (1952). Portfolio Selection. Journal of Finance.  

MVSK ve Polinom Hedef Programlama literatürü rapor içerisinde detaylı olarak sunulmuştur.
