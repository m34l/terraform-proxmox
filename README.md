# Konfigurasi Terraform Proxmox

Ini adalah repositori yang berisi file konfigurasi Terraform buat ngelola mesin virtual (VM) di Proxmox. Konfigurasi ini pakai provider Proxmox untuk bikin dan ngatur VM di server Proxmox.

## Prasyarat

- Punya Terraform yang udah diinstal di komputer lokal. Bisa di-download [di sini](https://www.terraform.io/downloads.html).
- Server Proxmox dengan akses API.
- Token API Proxmox dengan izin buat bikin dan ngatur VM.
- Kunci SSH buat cloud-init.
- Pastikan kamu udah menjalankan skrip `vm-template.sh` buat nyiapin template VM.

## Cara Setup

### Clone Repository

Pertama-tama, clone repo ini ke komputer lokal kamu:

```bash
git clone https://github.com/m34l/terraform-proxmox
cd terraform-proxmox
```
## Jalankan Skrip Template VM

### Sebelum jalanin konfigurasi


Terraform, kamu perlu nyiapin template VM. Jalankan skrip vm-template.sh buat bikin dan ngatur template ini:
```bash
chmod +x vm-template.sh
./vm-template.sh
```

Skrip ini bakal bikin template VM di server Proxmox kamu yang nanti dipakai buat cloning VM baru.

### Konfigurasi Kredensial Proxmox
Bikin file terraform.tfvars buat masukin detail API Proxmox:
```bash
proxmox_api_url     = ""
proxmox_api_token_id = ""
proxmox_api_token_secret = "
```

### Terapkan Konfigurasi Terraform
Sekarang, kamu udah siap buat jalankan Terraform:
```bash
terraform init
terraform plan
terraform apply
```

Masukkan yes buat konfirmasi. Terraform bakal bikin VM baru di Proxmox sesuai dengan konfigurasi yang ada.

### Penutup
Itu aja! Kalau ada masalah atau pertanyaan, jangan ragu buat ngontak atau buka issue di repo ini. Semoga bermanfaat!
