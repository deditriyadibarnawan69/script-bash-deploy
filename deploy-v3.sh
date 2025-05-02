#!/bin/bash

# Konfigurasi
SOURCE_DIR="/home/deddy/data-source"
DEST_DIR="/home/deddy/data-destination"
LOG_FILE="/var/log/deddy-sync.log"
CHOWN_TARGET="www-data:www-data"
CHMOD_TARGET="755"

# Fungsi logging
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Fungsi rsync copy + chown + chmod
copy_and_fix_permission() {
    echo "Menyalin data dari $SOURCE_DIR ke $DEST_DIR..."
    
    # Buat folder tujuan jika belum ada
    if [ ! -d "$DEST_DIR" ]; then
        mkdir -p "$DEST_DIR"
        log "Membuat folder tujuan: $DEST_DIR"
    fi

    # rsync tanpa mengubah permission & owner
    rsync -rltDv --delete "$SOURCE_DIR"/ "$DEST_DIR"/ \
        && log "Selesai rsync dari $SOURCE_DIR ke $DEST_DIR" \
        || log "Gagal menyalin dengan rsync"

    # Atur kepemilikan dan permission folder tujuan (tidak mengubah file dalamnya)
    chown -R "$CHOWN_TARGET" "$DEST_DIR"
    chmod -R "$CHMOD_TARGET" "$DEST_DIR"
    log "Set chown $CHOWN_TARGET dan chmod $CHMOD_TARGET untuk folder $DEST_DIR"
}

# Menu utama
main_menu() {
    while true; do
        echo "======================================"
        echo "   MENU UTAMA - DEDDY SYNC SCRIPT"
        echo "======================================"
        echo "1. Copy to docroot and set permission"
        echo "2. Exit"
        echo "--------------------------------------"
        echo -n "Pilih opsi [1-2]: "
        read -r choice

        case "$choice" in
            1) copy_and_fix_permission ;;
            2) log "Keluar dari script"; exit 0 ;;
            *) echo "Pilihan tidak valid. Coba lagi." ;;
        esac
        echo ""
    done
}

# Jalankan menu
main_menu
