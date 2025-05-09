#!/data/data/com.termux/files/usr/bin/bash

6ickCleaner.sh - Mini Termux cleanup tool with hacker vibes

Author: 6ickzone

Version: 1.0.0

IGNORE_FILE="$HOME/.6ickcleaner-ignore" BACKUP_DIR="$HOME/6ickcleaner-backup" GITHUB_REPO_URL="https://raw.githubusercontent.com/6ickzone/6ickCleaner/master/version.txt" SCRIPT_PATH="${BASH_SOURCE[0]}"

DRY_RUN=false TIMESTAMP=$(date +"%Y%m%d_%H%M%S") DELETED_ITEMS=() TOTAL_FREED=0 START_TIME=$(date +%s)

declare -a IGNORE_LIST if [[ -f "$IGNORE_FILE" ]]; then mapfile -t IGNORE_LIST < "$IGNORE_FILE" fi

confirm() { read -rp "$1 [y/N]: " ans [[ "$ans" =~ ^[Yy] ]] && return 0 || return 1 }

safe_delete() { local target="$1" for ig in "${IGNORE_LIST[@]}"; do [[ "$target" == "$ig" ]] && echo "[IGNORED] $target" && return done if $DRY_RUN; then echo "[DRY-RUN] would remove: $target" else if [[ -e "$target" ]]; then size=$(du -sb "$target" 2>/dev/null | awk '{print $1}') rm -rf "$target" [[ $? -eq 0 ]] && { DELETED_ITEMS+=("$target") TOTAL_FREED=$((TOTAL_FREED + size)) echo "[REMOVED] $target" } fi fi }

toggle_dry_run() { DRY_RUN=true; echo "[] Dry-run mode activated"; } clean_pkg_cache() { echo "[] Cleaning pkg cache..."; $DRY_RUN && echo "[DRY-RUN] pkg clean -y" || pkg clean -y; } clean_pip_cache() { echo "[] Cleaning pip cache..."; $DRY_RUN && echo "[DRY-RUN] pip cache purge" || pip cache purge; } clean_tmp()      { echo "[] Cleaning tmp directory..."; safe_delete "/data/data/com.termux/files/usr/tmp"; } clean_logs()     { echo "[*] Cleaning log directories..."; safe_delete "/data/data/com.termux/files/usr/var/log"; safe_delete "$HOME/storage/logs"; }

clean_large_files() { echo "[*] Scanning for large files (>50MB)..." mapfile -t list < <(find "$HOME" -type f -size +50M) for f in "${list[@]}"; do echo "Found large file: $f" confirm "Remove $f?" && safe_delete "$f" done }

clean_unused_pkgs() { echo "[*] Detecting unused packages..." mapfile -t list < <(comm -23 <(pkg list-installed | cut -d/ -f1 | sort) <(grep -oE "\w+" "$HOME/.bash_history" | sort -u)) for p in "${list[@]}"; do confirm "Uninstall package $p?" && { $DRY_RUN && echo "[DRY-RUN] pkg uninstall -y $p" || pkg uninstall -y "$p" } done }

backup_before_delete() { echo "[*] Creating backup archive..." mkdir -p "$BACKUP_DIR" archive="${BACKUP_DIR}/${TIMESTAMP}.tar.gz" $DRY_RUN && echo "[DRY-RUN] tar czf $archive $HOME" || (tar czf "$archive" "$HOME" && echo "Backup to $archive") }

clean_android_cache() { echo "[*] Running termux-cleanup-files..." if command -v termux-cleanup-files &>/dev/null; then $DRY_RUN && echo "[DRY-RUN] termux-cleanup-files" || termux-cleanup-files fi }

auto_update() { echo "[*] Checking for updates..." remote=$(curl -fsSL "$GITHUB_REPO_URL") || return localv="1.0.0" if [[ "$remote" != "$localv" ]]; then echo "Update available: $remote (current: $localv)" confirm "Install update?" && { curl -fsSL "https://raw.githubusercontent.com/6ickzone/6ickCleaner/master/6ickCleaner.sh" -o "$SCRIPT_PATH" chmod +x "$SCRIPT_PATH" echo "Updated. Relaunch script." exit 0 } else echo "Up-to-date (version $localv)." fi }

report_summary() { local end=$(date +%s) local dur=$((end - START_TIME)) echo; echo "===== 6ickCleaner Summary =====" echo "Deleted items: ${#DELETED_ITEMS[@]}" printf "Freed space: %.2f MB\n" "$(bc -l <<< "${TOTAL_FREED}/1048576")" echo "Duration: ${dur}s"; echo "=================================" }

main_menu() { clear cat << 'MENU'


---

/ | | |/ | || | || |   | | | | | |    | || | || || || | | | | || | | |__ | || |  |_   | | | |  _  | _||||    ||   || || |_| v1.0.0

1. Full Clean


2. Custom Clean


3. Dry Run + Full Clean


4. Check for Updates


5. Exit MENU read -rp "Choose [1-5]: " c case "$c" in

1. backup_before_delete; clean_pkg_cache; clean_pip_cache; clean_tmp; clean_logs; clean_large_files; clean_unused_pkgs; clean_android_cache; report_summary ;;


2. backup_before_delete; echo "Select tasks:"; confirm "PKG?" && clean_pkg_cache; confirm "PIP?" && clean_pip_cache; confirm "TMP?" && clean_tmp; confirm "LOGS?" && clean_logs; confirm "LARGE?" && clean_large_files; confirm "UNUSED?" && clean_unused_pkgs; confirm "ANDROID?" && clean_android_cache; report_summary ;;


3. toggle_dry_run; backup_before_delete; clean_pkg_cache; clean_pip_cache; clean_tmp; clean_logs; clean_large_files; clean_unused_pkgs; clean_android_cache; report_summary ;;


4. auto_update ;;


5. echo "Bye, bro!"; exit ;; *) echo "Invalid choice." ;; esac }





main_menu

