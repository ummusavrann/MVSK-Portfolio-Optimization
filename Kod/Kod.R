

##  TEZ KODLARI

# GEREKLİ KÜTÜPHANLERİN YÜKLENMESİ:

library(readxl)
library(PerformanceAnalytics)
library(quadprog)
library(Rsolnp)

# VERİ SETİ YÜKLEME:

library(readxl)

TEZZ <- read_excel("C:/Users/Lenovo/Desktop/TEZZ.xlsx")

View(TEZZ)

df_new<- TEZZ

# Veri setini matrise dönüştürme
df_new <- as.matrix(df_new)

# Başlangıç ve son fiyatları belirleme
baslangic_fiyatlari_degisken12 <- df_new[-nrow(df_new), ]  # Son satır hariç tüm satırları alır
son_fiyatlari_degisken12 <- df_new[-1, ]  # İlk satır hariç tüm satırları alır

# Log getiriyi hesaplama
df_new <- log(son_fiyatlari_degisken12 / baslangic_fiyatlari_degisken12)

# Sütunların ortlamasını hesaplama

ort <- colMeans(df_new) 
ort

# Varyans Kovaryans matrisi
V <- var(df_new)
V

# Değişkenlerin Çarpıklık değerlerini hesaplama

skewness(df_new)

# Değişkenlerin Basıklık değerlerini hesaplama

kurtosis(df_new)

# Değişknelerin Normal dağılımlarını test etme

arcelik <- shapiro.test(df_new$arcelik_acilis)
arcelik

akbank <- shapiro.test(df_new$akbank_acilis)
akbank

thy <- shapiro.test(df_new$thy_acilis)
thy

# Skewness - Coskewness Matrisi Elde Etme:

#### Yöntem1:

m3 <- M3.MM(df_new)
m3

#### Yöntem 2:

returns<-df_new

coskewness_matrix <- function(returns) {
  n <- ncol(returns)
  T <- nrow(returns)
  
  m3 <- array(0, dim = c(n, n, n))
  
  for (i in 1:n) {
    for (j in 1:n) {
      for (k in 1:n) {
        m3[i, j, k] <- sum((returns[, i] - mean(returns[, i])) * 
                             (returns[, j] - mean(returns[, j])) * 
                             (returns[, k] - mean(returns[, k]))) / T
      }
    }
  }
  
  return(m3)
}

coskewness_values <- coskewness_matrix(returns)

print(coskewness_values)

# Kurtosis - Kokurtosis Matrisi Elde Etme:

#### Yöntem 1:

m4<- M4.MM(df_new)
m4

#### Yöntem 2:

cokurtosis_matrix <- function(returns) {
  n <- ncol(returns)
  T <- nrow(returns)
  
  m4 <- array(0, dim = c(n, n, n, n))
  
  for (i in 1:n) {
    for (j in 1:n) {
      for (k in 1:n) {
        for (l in 1:n) {
          m4[i, j, k, l] <- sum((returns[, i] - mean(returns[, i])) * 
                                  (returns[, j] - mean(returns[, j])) * 
                                  (returns[, k] - mean(returns[, k])) * 
                                  (returns[, l] - mean(returns[, l]))) / T
        }
      }
    }
  }
  
  return(m4)
}

cokurtosis_values <- cokurtosis_matrix(returns)

print(cokurtosis_values)

# PORTFÖY OPTİMİZASYONU

# Değişkenlerin ve matrislerin tanımlanması
n <- 10000  # Toplam portföy sayısı
c <- length(ort)  # Varlık sayısı
avec <- matrix(nrow = n, ncol = c)  # Ağırlık matrisinin tanımlanması
Port <- matrix(nrow = n, ncol = 1)  # Portföy ortalama getirisi matrisi
Pstd <- matrix(nrow = n, ncol = 1)  # Portföy standart sapması matrisi
Pcoskewness <- matrix(nrow = n, ncol = 1)  # Portföy coskewness matrisi
Pcocurtosis <- matrix(nrow = n, ncol = 1)  # Portföy cocurtosis matrisi

# Döngü başlatılarak portföylerin oluşturulması ve metriklerin hesaplanması
for (i in 1:n) {
  repeat {
    # Birinci ağırlığın belirlenmesi
    avec1 <- runif(1, min = 0, max = 1)
    
    # İkinci ağırlığın uniform dağılıma göre belirlenmesi
    avec2 <- runif(1, min = 0, max = 0.5)
    
    # Üçüncü ağırlığın hesaplanması
    avec3 <- 1 - avec1 - avec2
    
    # Ağırlıkların 0'dan büyük olup olmadığının kontrolü
    if (avec1 > 0 && avec2 > 0 && avec3 > 0) {
      break  # Geçerli ağırlık seti bulununca döngüden çık
    }
  }
  
  # Geçerli ağırlık setinin matrise eklenmesi
  avec[i, ] <- c(avec1, avec2, avec3)
  
  # Ağırlıklar vektörünün sütun matrisine dönüştürülmesi
  tavec <- matrix(avec[i, ], nrow = 3, ncol = 1)
  
  # Portföyün beklenen getirisinin hesaplanması
  Port[i, 1] <- ort %*% tavec
  
  # Portföyün standart sapmasının hesaplanması
  Pstd[i, 1] <- sqrt(avec[i, ] %*% V %*% tavec)
  
  # Portföyün coskewness değerinin hesaplanması
  Pcoskewness[i, 1] <- PerformanceAnalytics:::portm3(avec[i, ], M3.MM(df_new))
  
  # Portföyün cocurtosis değerinin hesaplanması
  Pcocurtosis[i, 1] <- PerformanceAnalytics:::portm4(avec[i, ], M4.MM(df_new))
}

# Portföyün Saçılım grafiği
plot(Pstd,Port, main = "Portfoyun Ortalama - Varyans Dağılım Grafiği", xlab = "Portföy Varyansı",ylab = "Portföy Ortalaması", col = "lightgreen",pch = 1, cex = 0.7)

plot(Pstd, Port, main = "Portfoyun Ortalama - Varyans Dağılım Grafiği", 
     xlab = "Portfoy Varyansı", ylab = "Portfoy  Ortalaması", 
     col = "lightgreen", pch = 1, cex = 0.7, 
     cex.main = 1.2, cex.lab = 1.0, cex.axis = 0.8)
min_Pstd <- min(Pstd) # Minimum Pstd değerini ve karşılık gelen Port değerini bulun
corresponding_Port <- Port[which.min(Pstd)]
points(min_Pstd, corresponding_Port, col = "darkgreen", pch = 19, cex = 2)



# PORTFÖY OPTİMİZASYONU VE SİMÜLASYONU

# 1. Değişkenlerin Tanımlanması
nn <- length(ort)  # Portföydeki varlık sayısı
Q <- 2 * V  # Q matrisinin tanımlanması (portföy optimizasyonu için)
dvec <- rep(0, nn)  # dvec vektörünün tanımlanması (optimizasyon için)
mm <- 1000  # Simülasyon sayısı

# 2. Matrislerin Oluşturulması
avecY <- matrix(nrow = mm, ncol = nn)  # Ağırlık matrisi
SNC <- matrix(nrow = mm, ncol = 5 + nn)  # Sonuç matrisi (hedef, ort, std, coskewness, cocurtosis, ağırlıklar)

# 3. Simülasyonların Gerçekleştirilmesi
for (kk in 1:mm) {
  # 3.1. Hedef Getirinin Hesaplanması
  hedef <- min(ort) + (max(ort) - min(ort)) / mm * kk  # Hedef getiri değerinin hesaplanması
  
  # 3.2. Kısıt Matrislerinin Oluşturulması
  Amat <- cbind(ort, rep(1, nn), diag(nn))  # Kısıtlar matrisi
  bvec <- c(hedef, 1, rep(0, nn))  # Kısıtlar vektörü
  
  # 3.3. Quadratik Programlama ile Optimizasyonun Çözülmesi
  avecY[kk, ] <- solve.QP(Q, dvec, Amat, bvec, meq = 1)$solution
  
  # 3.4. Ağırlıklar Vektörünün Sütun Matrisine Dönüştürülmesi
  ttavec <- matrix(avecY[kk, ], nrow = nn, ncol = 1)
  
  # 3.5. Sonuçların Hesaplanması ve Matrise Eklenmesi
  SNC[kk, 1] <- hedef  # Hedef getiri
  SNC[kk, 2] <- ort %*% ttavec  # Portföyün beklenen getirisi
  SNC[kk, 3] <- sqrt(avecY[kk, ] %*% V %*% ttavec)  # Portföyün standart sapması
  SNC[kk, 4] <- PerformanceAnalytics:::portm3(avecY[kk, ], M3.MM(df_new))  # Portföyün coskewness değeri
  SNC[kk, 5] <- PerformanceAnalytics:::portm4(avecY[kk, ], M4.MM(df_new))  # Portföyün cocurtosis değeri
  SNC[kk, 6:(5 + nn)] <- avecY[kk, ]  # Ağırlıklar
}

# Sonuç matrisi 'SNC' artık portföylerin hedef getirilerini, beklenen getirilerini, 
# standart sapmalarını, coskewness ve cocurtosis değerlerini ve ağırlıklarını içermektedir.


### PGP MODEL İÇİN MAKSİMİZASYON VE MİNİMİZASYON İŞLEMLERİ:

# Optimizasyon için başlangıç ağırlıkları
initial_weights <- rep(1/3, 3)

# Kısıt fonksiyonu: Ağırlıkların toplamı 1 olmalı
constraint_function <- function(avec) {
  return(sum(avec) - 1)
}

# Alt Problem 1: Beklenen Getiriyi Maksimize Etme
objective_function_R <- function(avec) {
  return(-sum(ort * avec))  # Negatif işaret çünkü minimizasyon yapacağız
}
result_R <- solnp(
  pars = initial_weights,
  fun = objective_function_R,
  eqfun = constraint_function,
  eqB = 0,
  LB = rep(0, 3),
  UB = rep(1, 3)
)
R_star <- -result_R$values[length(result_R$values)]
result_R$pars
# Alt Problem 2: Varyansı Minimize Etme
objective_function_V <- function(avec) {
  return(t(avec) %*% V %*% avec)
}
result_V <- solnp(
  pars = initial_weights,
  fun = objective_function_V,
  eqfun = constraint_function,
  eqB = 0,
  LB = rep(0, 3),
  UB = rep(1, 3)
)
V_star <- sqrt(result_V$values[length(result_V$values)])

aaa<- result_V$pars
t(aaa) %*% V %*% aaa

# Alt Problem 3: Coskewness'i Maksimize Etme
objective_function_S <- function(avec) {
  return(-PerformanceAnalytics:::portm3(avec, M3.MM(df_new)))
}
result_S <- solnp(
  pars = initial_weights,
  fun = objective_function_S,
  eqfun = constraint_function,
  eqB = 0,
  LB = rep(0, 3),
  UB = rep(1, 3)
)
S_star <- -result_S$values[length(result_S$values)]

# Alt Problem 4: Cocurtosis'i Minimize Etme
objective_function_K <- function(avec) {
  return(PerformanceAnalytics:::portm4(avec, M4.MM(df_new)))
}
result_K <- solnp(
  pars = initial_weights,
  fun = objective_function_K,
  eqfun = constraint_function,
  eqB = 0,
  LB = rep(0, 3),
  UB = rep(1, 3)
)
K_star <- result_K$values[length(result_K$values)]


#### POLİNOM HEDEF PROGRAMLAMA 

# Hedef fonksiyonları ve lambda değerleri:

### lambda değerleri (1,0,0,0) (0,1,0,0) (0,0,1,0) (0,0,0,1) (1,1,0,0,) ve (1,1,1,1) 
### olacak şekilde güncellenerek  Port1 - Pstd1, Port2 - Pstd2, Port3 - Pstd3, Port4 - Pstd4,
### Port5 - Pstd5, Port6 - Pstd6 hesaplanmıştır.

lambda1 <- 1
lambda2 <- 1
lambda3 <- 1
lambda4 <- 1

# PGP Amaç Fonksiyonu
objective_function_PGP <- function(avec) {
  Port <- sum(ort * avec)
  Pstd <- sqrt(t(avec) %*% V %*% avec)
  Pcoskewness <- PerformanceAnalytics:::portm3(avec, M3.MM(df_new))
  Pcocurtosis <- PerformanceAnalytics:::portm4(avec, M4.MM(df_new))
  
  d1 <- max(0, R_star - Port)
  d2 <- max(0, Pstd - V_star)
  d3 <- max(0, S_star - Pcoskewness)
  d4 <- max(0, Pcocurtosis - K_star)
  
  Z <- (abs(d1 / R_star))^lambda1 + (abs(d2 / V_star))^lambda2 + 
    (abs(d3 / S_star))^lambda3 + (abs(d4 / K_star))^lambda4
  
  return(Z)
}

# Optimizasyon çözümü
result_PGP <- solnp(
  pars = initial_weights,
  fun = objective_function_PGP,
  eqfun = constraint_function,
  eqB = 0,
  LB = rep(0, 3),
  UB = rep(1, 3)
)
optimum_weights <- result_PGP$pars
print(optimum_weights) 



avecX<- result_PGP$pars
print(avecX)  # Optimum ağırlıkları yazdır

#avecX <- c(1/4, 2/4, 1/4)

#(1, 1, 1, 1)
Port6 <- sum(ort * avecX)
Port6
Pstd6 <- sqrt(t(avecX) %*% V %*% avecX)
Pstd6

#(1, 1, 0, 0)
Port5 <- sum(ort * avecX)
Port5
Pstd5 <- sqrt(t(avecX) %*% V %*% avecX)
Pstd5

#(0, 0, 0, 1)
Port4 <- sum(ort * avecX)
Port4
Pstd4 <- sqrt(t(avecX) %*% V %*% avecX)
Pstd4

#(0, 0, 1, 0)
Port3 <- sum(ort * avecX)
Port3
Pstd3 <- sqrt(t(avecX) %*% V %*% avecX)
Pstd3


# (0, 1, 0, 0)
Port2 <- sum(ort * avecX)
Port2
Pstd2 <- sqrt(t(avecX) %*% V %*% avecX)
Pstd2
Pcoskewness2 <- PerformanceAnalytics:::portm3(avecX, M3.MM(df_new))
Pcoskewness2
Pcocurtosis2 <- PerformanceAnalytics:::portm4(avecX, M4.MM(df_new))
Pcocurtosis2

# (1, 0, 0, 0)
Port1 <- sum(ort * avecX)
Port1
Pstd1 <- sqrt(t(avecX) %*% V %*% avecX)
Pstd1
Pcoskewness1 <- PerformanceAnalytics:::portm3(avecX, M3.MM(df_new))
Pcoskewness1
Pcocurtosis1 <- PerformanceAnalytics:::portm4(avecX, M4.MM(df_new))
Pcocurtosis1



# PORTFÖY ORTALAMA VARYANS DAĞILIM GRAİĞİNDE PORTFÖY DEĞERLERİNİN DAĞILIMI:

plot(Pstd, Port, main = "Portfoyun Ortalama - Varyans Dağılım Grafiği", 
xlab = "Portfoy Varyansı", ylab = "Portfoy  Ortalaması", 
col = "lightgreen", pch = 1, cex = 0.7, 
cex.main = 1.2, cex.lab = 1.0, cex.axis = 0.8)

# Minimum Pstd değerini ve karşılık gelen Port değerini bulun

# 1000
min_Pstd1 <- min(Pstd1)
corresponding_Port1 <- Port1[which.min(Pstd1)]
points(Pstd1, Port1, col = "black", pch = 19, cex = 2)
# 0100
min_Pstd2 <- min(Pstd2)
corresponding_Port2 <- Port2[which.min(Pstd2)]
points(Pstd2, Port2, col = "darkred", pch = 19, cex = 2)
#0010
min_Pstd3 <- min(Pstd3)
corresponding_Port3 <- Port3[which.min(Pstd3)]
points(Pstd3, Port3, col = "darkgreen", pch = 19, cex = 2)
#0001
min_Pstd4 <- min(Pstd4)
corresponding_Port4 <- Port4[which.min(Pstd4)]
points(Pstd4, Port4, col = "darkgray", pch = 19, cex = 2)
#1100
min_Pstd5 <- min(Pstd5)
corresponding_Port5 <- Port5[which.min(Pstd5)]
points(Pstd5+0.0001, Port5, col = rgb(255, 192, 203, maxColorValue=255, alpha=150), pch = 19, cex = 2)
#1111
Port6 <- sum(ort * avecX)
Pstd6 <- sqrt(t(avecX) %*% V %*% avecX)

# Hesaplanan noktayı grafiğe ekleyin
points(Pstd6, Port6, col = "blue", pch = 19, cex = 2)

# Efsane (legend) ekleme
legend("bottomright", legend = c("(1, 0, 0, 0)", "(0, 1, 0, 0)", "(0, 0, 1, 0)", "(0, 0, 0, 1)", "(1, 1, 0, 0)", "(1, 1, 1, 1)"),
       col = c("black", "darkred", "darkgreen", "darkgray", "pink", "blue"), pch = 19, cex = 0.8,  pt.cex = 1.5)




