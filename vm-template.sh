#!/bin/bash

# Definisikan variabel untuk nama image dan ID template
export TEMPLATE_IMAGE="jammy-server-cloudimg-amd64"
export TEMPLATE_ID=9000
export PROXMOX_NODE=""  # Sesuaikan dengan node Proxmox Anda

# Update dan instal libguestfs-tools
sudo apt update -y
sudo apt install libguestfs-tools -y

# Unduh image Ubuntu jika belum ada
if [ ! -f "${TEMPLATE_IMAGE}.img" ]; then
    wget https://cloud-images.ubuntu.com/jammy/current/${TEMPLATE_IMAGE}.img
fi

# Konfigurasikan image dengan perangkat lunak tambahan dan enable qemu-guest-agent
sudo virt-customize -a ${TEMPLATE_IMAGE}.img --install qemu-guest-agent,ncat,mc,net-tools,bash-completion --run-command 'systemctl enable qemu-guest-agent.service'

# Salin image untuk digunakan sebagai template
cp ${TEMPLATE_IMAGE}.img ${TEMPLATE_IMAGE}.qcow2

# Resize image menjadi 20GB
qemu-img resize ${TEMPLATE_IMAGE}.qcow2 20G

# Hapus VM dengan ID template jika sudah ada
qm destroy ${TEMPLATE_ID} --purge

# Buat VM baru dengan konfigurasi dasar
qm create ${TEMPLATE_ID} --name ubuntu-2204-cloudinit-template --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0

# Impor disk image ke Proxmox
qm importdisk ${TEMPLATE_ID} ${TEMPLATE_IMAGE}.qcow2 local-lvm

# Atur disk dan perangkat keras lainnya
qm set ${TEMPLATE_ID} --scsihw virtio-scsi-single --scsi0 local-lvm:vm-${TEMPLATE_ID}-disk-0,cache=none,ssd=1,discard=on
qm set ${TEMPLATE_ID} --boot c --bootdisk scsi0
qm set ${TEMPLATE_ID} --ide2 local-lvm:cloudinit
qm set ${TEMPLATE_ID} --serial0 socket --vga serial0
qm set ${TEMPLATE_ID} --agent enabled=1

# Tambahkan kunci SSH untuk akses ke VM
#echo "ssh-rsa AAAAB3Nza...your-public-key... user@hostname" > ~/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2MspIgK6VArJU0lIa6JRPtOT7WVD46007mKkYsxieA8s4OcuJlWnPIybW+LVtrwPcjDnMT1odzvvpZ19TYKiTHpHlYxc4rvtGafB3Ypl2KalGHM4IU8fGSy/dg4ZccGewVgyQQgnZCIzGFDEkjdIqH43NUMQRbgjcZqhFOi2L6VoA0dLGlLpbLoXzhTA+oJvVJmP6Ikk4U7/dMpEisaufix8nSHSQ789Ije/c+47G0DA4HTDVV2FwhJ+cXLKzjJWJZCiG1hQCHT8fpQxtEu4C1lhQ0vXnoGsSaoAkTLwqE9HDPW1L5vo7arMyHWZBI0jLpK8rW+f9ald6v2KuG4KECK2mAa5uaJuNck774U6nM77Wf/o7EeQk4nnE0CWJLcTfR3wA0BMLRSMT33p6JNcN7z41PYvDaFUplf2Umup0ZSTZc85Kd3jhMlilgMJaxeH2V9Sg1eM9aEvSsXAbFBf9sgqfSb8yC9+xJeStQbeILFq5Lt+oi6nqCdX6ze5VeVCkj1PQea/oUMdAmMFrLjakux+AqK6xfVbO3FZ8pIonrPamhNlMW8cnGljqNmsYboyva1bB7dRq9BVEMwzOE/5E4g8gBCaStOK50zsomrt0q3O588J+XKvKsKsChOSmyoFDA0SeO/lACGSAsGRS2YUhw67Rq4vuIxp4Mpw9+o2WPw== devops@m34lnetwork.co.id" > ~/authorized_keys

# Atur konfigurasi cloud-init
qm set ${TEMPLATE_ID} --ipconfig0 "ip6=auto,ip=dhcp"
qm set ${TEMPLATE_ID} --sshkeys ~/authorized_keys
qm set ${TEMPLATE_ID} --ciuser devops
qm set ${TEMPLATE_ID} --cipassword KONTOLODON

# Jadikan VM sebagai template
qm template ${TEMPLATE_ID}

echo "Template VM dengan ID ${TEMPLATE_ID} telah berhasil dibuat."