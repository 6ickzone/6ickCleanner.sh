# 6ickCleanner

![6ickCleanner Logo](https://raw.githubusercontent.com/6ickzone/6ickCleanner/master/banner.png)

**6ickCleanner** — Mini cleanup tool untuk Termux dengan sentuhan hacker vibes ala 0x6ick.  
Optimalkan ruang, bersihkan cache, deteksi file besar, dan auto-update langsung dari GitHub.

> Made with ✦ by [0x6ick](https://github.com/6ickzone)

---

## ✦ Fitur Utama
- Clean **pkg cache**, **pip cache**, **tmp**, dan **log** directory
- Scan dan hapus file besar (>50MB)
- Deteksi package yang jarang dipakai (30 hari)
- Backup otomatis sebelum bersih-bersih
- **Dry-run mode** (simulasi tanpa hapus beneran)
- Auto-update langsung dari GitHub

---

## ✦ Installasi

```bash
# Masuk ke ~/bin dan download script
mkdir -p ~/bin
cd ~/bin
curl -O https://raw.githubusercontent.com/6ickzone/6ickCleanner/master/6ickCleaner.sh
chmod +x 6ickCleaner.sh

# Jalankan
~/bin/6ickCleaner.sh

✦ Cara Pakai

Jalankan script lalu pilih menu:

1) Full Clean
2) Custom Clean
3) Dry Run + Full Clean
4) Check for Updates
5) Exit

Full Clean = semua dibersihkan otomatis

Custom Clean = pilih manual

Dry Run = lihat simulasi, aman tanpa hapus data

✦ Update Script

Gunakan menu nomor 4 untuk cek versi baru.
Script otomatis unduh & update jika ada versi terbaru di repo ini.

---

✦ Credit

🛠️ Author: 0x6ick

📂 Repo: 6ickCleanner
