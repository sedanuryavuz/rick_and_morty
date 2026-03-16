# Rick & Morty Character Explorer

Find characters across infinite realities.

Rick & Morty evrenindeki karakterleri keşfetmenizi sağlayan modern bir Flutter uygulamasıdır.  
Uygulama, Rick & Morty Public API kullanarak karakter bilgilerini, bölümleri ve karakter detaylarını görüntülemeyi sağlar.

Kullanıcılar karakterleri arayabilir, durumlarına göre filtreleyebilir, popüler karakterleri görüntüleyebilir ve karakterlerin yer aldığı bölümleri inceleyebilir.

---

# Özellikler

- Rick & Morty karakterlerini listeleme
- Karakter ismine göre arama
- Duruma göre filtreleme (Alive, Dead, Unknown)
- Sonsuz scroll (pagination)
- Karakter detay sayfası
- Karakterin yer aldığı bölümleri görüntüleme
- Trending karakterler bölümü
- Quick Discover karakter listesi
- Bölümler
- Scroll to top butonu
- Modüler ve temiz mimari

---

# Tech Stack

Bu proje aşağıdaki teknolojiler kullanılarak geliştirilmiştir:

- Flutter
- Dart
- Provider (State Management)
- REST API
- Layered Architecture

 ---
 
# Proje Mimarisi

lib
├── app
│   └── theme
├── core
│   ├── constants
│   ├── enums
│   └── network
├── data
│   ├── models
│   ├── repositories
│   └── services
└── presentation
    ├── controllers
    └── pages
    └── widgets


---

# Uygulama Sayfaları

## Ana Sayfa

- Quick Discover karakterleri
- Trending karakterler
- İlk 5 Bölümler

## Karakter Listesi

- Karakter arama
- Duruma göre filtreleme
- Sonsuz scroll

## Karakter Detayı

- Karakter bilgileri
- Karakterin yer aldığı bölümler
- Scroll to top butonu

---

# Kullanılan API

Bu proje aşağıdaki public API kullanılarak geliştirilmiştir:

https://rickandmortyapi.com/

Kullanılan endpointler:

- `/character`
- `/episode`

---

# Ekran Görüntüleri

Uygulamaya ait ekran görüntüleri aşağıda yer almaktadır.



