# 😋 AngkringanPedia 😋

## 🔗 Tautan Progress Tracker
https://docs.google.com/spreadsheets/d/1N2a_wzHApscAcT2jkCYGwbxMVowg98ffWWfUY7l6-Ls/edit?usp=sharing

## 📜 Backstory AngkringanPedia

Indonesia memiliki warisan kuliner yang kaya, dan salah satu tradisi paling ikonik adalah angkringan—warung kecil di pinggir jalan yang menawarkan makanan dan minuman sederhana dengan harga terjangkau. Dari nasi kucing yang legendaris hingga berbagai pilihan sate dan gorengan, angkringan adalah tempat yang menyatukan orang dari berbagai lapisan masyarakat untuk berbincang, menikmati suasana, dan berbagi cerita.
Namun, tidak semua orang bisa menemukan angkringan favorit mereka dengan mudah, terutama di tengah semakin banyaknya pilihan kuliner yang ada. Terinspirasi oleh semangat kebersamaan dan kehangatan dari angkringan, lahirlah AngkringanPedia.

## 🤔 Apa itu AngkringanPedia?

Yuk, pecinta angkringan! Bosan bingung mau makan apa? AngkringanPedia solusinya! Dengan AngkringanPedia, kamu bisa puas menjelajah ribuan menu angkringan favoritmu, dari nasi kucing yang bikin nagih sampai gorengan yang renyah. Mau cari sate favorit? Tinggal klik! Bikin ulasan dan rating, bagi rekomendasi sama teman-teman, dan jadi bagian dari komunitas pecinta angkringan terbesar! Yuk, cobain sekarang dan rasakan sensasi kuliner angkringan yang makin seru!

## 🫂 Anggota Kelompok 
| NPM | Name | GitHub Account | 
| -- | -- | -- |
| 2306152430 | Malvin Scafi | [Cyades](https://github.com/Cyades) |
| 2306227955 | Ischika Afrilla | [kaachiii](https://github.com/kaachiii) |
| 2306216075 | Juan Lukius Barnaby | [juanlukius](https://github.com/juanlukius) |
| 2306221970 | Arya Gilang Prasetya | [AryaGilangP](https://github.com/AryaGilangP) |
| 2306202826 | Nobel Julian Bintang | [nobeljb](https://github.com/nobeljb) |

## 🗂️ Modul

### 🔐 Admin and Authentication

**Dikerjakan oleh Ischika Afrilla**

Modul ini mencakup fitur untuk mengelola akun pengguna dan admin, termasuk autentikasi untuk akses ke aplikasi.

Fungsi Modul:

- Registrasi: Mengizinkan pengguna dan admin untuk mendaftar akun baru.
- Login: Menyediakan mekanisme login berbasis email/username dan password untuk pengguna dan admin.
- Logout: Menyediakan tombol logout untuk menghentikan sesi pengguna.
- Manajemen Admin: Admin dapat menambah, menghapus, atau mengedit informasi akun admin sendiri.
- Pengawasan Akun: Admin dapat melihat dan mengedit akun pengguna, memastikan hanya akun yang sah yang bisa mengakses sistem.

Berikut aksi yang dapat dilakukan masing-masing _role_:
| User | Guest | Admin |
| ---- | ----- | ----- |
| Registrasi akun | Registrasi akun	| Mengelola data pengguna (admin atau user) | 
| Login akun | Login akun | Mengawasi akun pengguna (admin atau user) |
| Logout akun | - | Tambah/Hapus akun pengguna (admin atau user) |


### 🖥️ Dashboard and Artikel

**Dikerjakan oleh Arya Gilang Prasetya**

Modul Dashboard berfungsi sebagai pusat informasi pribadi pengguna yang memuat data dan memberikan opsi untuk mengeditnya.

Fungsi Modul:
- Informasi Pengguna: Menampilkan informasi pribadi pengguna seperti nama, umur, nomor handphone, dan alamat.
- Edit Profil: Pengguna dapat mengubah informasi pribadi melalui fitur ini.
- Keamanan Data: Pengelolaan data pribadi secara aman, termasuk kemampuan admin untuk memantau perubahan.

Berikut aksi yang dapat dilakukan masing-masing _role_:
| User | Guest | Admin |
| ---- | ----- | ----- |
| Melihat dan mengedit profil | - | Melihat data pengguna |
| Memperbarui informasi pribadi	| - | Mengedit informasi pengguna |
| - | - | Menghapus akun pengguna |

Modul Artikel dirancang untuk memberikan informasi tambahan kepada pengguna melalui artikel yang relevan dengan topik makanan, gaya hidup sehat, atau berita terkini terkait kuliner. Modul ini membantu meningkatkan pengalaman pengguna dengan konten yang informatif dan menarik.

Fungsi Modul:

Penjelajahan Artikel: Menyediakan daftar artikel yang dapat dibaca oleh pengguna.
- Detail Artikel: Memungkinkan pengguna melihat detail artikel termasuk gambar, judul, isi, dan tanggal publikasi.
- Manajemen Artikel (Admin): Admin dapat membuat, mengedit, dan menghapus artikel yang tersedia di platform.

Berikut aksi yang dapat dilakukan masing-masing _role_:
| User | Guest | Admin |
| ---- | ----- | ----- |
| Melihat isi artikel | Melihat isi artikel | Mengedit artikel |
| Melihat daftar artikel | Melihat daftar artikel | Menambahkan artikel |
| Menandai artikel favorit	| - | Menghapus artikel |

### 🏠 Homepage, Search and Filter

**Dikerjakan oleh Malvin Scafi**

Modul Homepage menyediakan fungsi pencarian dan filter untuk membantu pengguna menemukan makanan sesuai preferensi.

Fungsi Modul:
- Membuat Navigation Bar, Footer dan Homepage
- Daftar Makanan: Menampilkan daftar restoran dan menu makanan yang tersedia di platform.
- Pencarian: Pengguna dapat menggunakan fitur pencarian untuk menemukan makanan tertentu.
- Filter: Menyediakan filter berdasarkan kategori, rating, bahan baku, dan harga untuk mempermudah pencarian.

Berikut aksi yang dapat dilakukan masing-masing _role_:
| User | Guest | Admin |
| ---- | ----- | ----- |
| Melihat daftar makanan | Melihat daftar makanan | Menambahkan/menghapus makanan |
| Menggunakan fitur pencarian | Menggunakan fitur pencarian	| Menggunakan fitur pencarian |
| Menggunakan fitur filter | Menggunakan fitur filter | Menggunakan fitur filter |


### 🔍 Food Catalog

**Dikerjakan oleh Nobel Julian Bintang**

Modul ini menampilkan katalog makanan yang memungkinkan pengguna untuk melihat detail produk, memberikan ulasan, dan memberikan rating.

Fungsi Modul:
- Detail Produk Makanan: Menyediakan informasi lengkap mengenai setiap makanan, termasuk deskripsi, harga, dan gambar.
- Rating dan Ulasan Produk: Pengguna dapat memberikan rating dan menulis ulasan pada makanan, dan rating rata-rata akan diperbarui secara otomatis.

Berikut aksi yang dapat dilakukan masing-masing _role_:
| User | Guest | Admin |
| ---- | ----- | ----- |
| Melihat detail produk makanan | Melihat detail produk makanan | Melihat detail produk makanan |
| Memberi ulasan dan rating, dan mengedit/menghapus ulasan dan rating tersebut | - | Mengedit, atau menghapus ulasan dan rating |
| Melihat rating rata-rata | Melihat rating rata-rata | Melihat rating rata-rata |


### ⭐ Favourite

**Dikerjakan oleh Juan Lukius Barnaby**

Modul Favorit memungkinkan pengguna untuk menandai restoran atau makanan yang mereka sukai agar mudah diakses kembali.

Fungsi Modul:
- Menandai Favorit: Pengguna dapat menandai makanan atau restoran sebagai favorit.
- Daftar Favorit: Pengguna dapat melihat daftar favorit yang menampilkan gambar, nama, dan informasi dasar.
- Mengelola Favorit Pengguna: Admin dapat melihat daftar favorit pengguna dan menghapus favorit yang dianggap tidak relevan atau tidak sesuai dengan kebijakan platform.
- Akses ke Detail: Dari daftar favorit, pengguna bisa langsung mengakses halaman detail untuk memberikan ulasan atau melihat informasi lebih lanjut.

Berikut aksi yang dapat dilakukan masing-masing _role_:
| User | Guest | Admin |
| ---- | ----- | ----- |
| Menambah/menghapus favorit | - | Mengelola favorit pengguna |
| Melihat daftar favorit | - | Melihat dan menghapus favorit pengguna |
| Mengakses halaman detail dari favorit | - | - |


## 📝 Dataset

AngkringanPedia mengambil dataset dari [Menu Angkringan Jogja](https://cookpad.com/id/cari/menu%20angkringan%20jogja)

Berikut merupakan dataset yang sudah di convert menjadi .json --> [Dataset](dataset.json) 


## 🎭 Jenis Pengguna (_Role_)

Pada aplikasi kami, terdapat tiga jenis pengguna:

- User
- Guest
- Admin

Penjelasan lebih rinci tentang setiap jenis pengguna dan kewenangannya dalam aplikasi tersedia di deskripsi masing-masing modul.


## 🌊 Alur Pengintegrasian

1. Setup Awal di Django:
    - Membuat django-app authentication
    - Menginstall django-cors-headers untuk menangani Cross-Origin Resource Sharing
    - Mengkonfigurasi settings.py untuk mengizinkan koneksi dari Flutter
    ```python
    CORS_ALLOW_ALL_ORIGINS = True
    CORS_ALLOW_CREDENTIALS = True
    CSRF_COOKIE_SECURE = True
    SESSION_COOKIE_SECURE = True
    ```
    - Menambahkan "10.0.2.2" ke ALLOWED_HOSTS untuk akses dari emulator Android

2. Membuat Endpoint API di Django:
    - Membuat views untuk authentication (login/register)
    - Membuat views untuk operasi CRUD
    - Mengatur routing URL untuk endpoint-endpoint tersebut
    - Memastikan endpoint mengembalikan response dalam format JSON

3. Setup Flutter:
    - Menginstall package pbp_django_auth dan provider
    - Mengkonfigurasi Provider di main.dart untuk state management
    - Membuat model sesuai dengan struktur JSON dari Django

4. Alur Komunikasi:

    a. Login:

    - User memasukkan credentials di Flutter
    - Flutter mengirim POST request ke endpoint Django (/auth/login/)
    - Django memverifikasi dan mengembalikan response
    - Flutter menyimpan session cookie jika login berhasil

    b. Operasi CRUD:

    - Flutter mengirim request ke endpoint Django dengan cookie session
    - Django memverifikasi session dan mengeksekusi operasi
    - Django mengembalikan response JSON
    - Flutter memproses response dan update UI

5. Contoh Flow Request:
    ```text
    Flutter App -> HTTP Request -> Django Server
                                    |
                                Verify Session
                                    |
                            Process Request
                                    |
    Flutter App <- JSON Response <- Django Server
    ```

6. Format Komunikasi
    - Request dari Flutter:
        ```dart
        final response = await request.login(
            "http://your-url/auth/login/",
            {'username': username, 'password': password}
        );
        ```
    - Response dari Django:
        ```python
        return JsonResponse({
            "status": True,
            "message": "Login sukses!",
            "username": user.username
        })
        ```

7. Keamanan 
    - Menggunakan CSRF token untuk keamanan
    - Implementasi session management
    - Validasi input di kedua sisi (Flutter dan Django)
    - HTTPS untuk komunikasi yang aman (wajib untuk production)
