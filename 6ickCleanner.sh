#!/data/data/com.termux/files/usr/bin/bash
# 6ickCleaner.sh - Mini Termux cleanup tool with hacker vibes
# Author: 6ickzone
# Version: 1.1.0

# CONFIGURATION\IGNORE_FILE="$HOME/.6ickcleaner-ignore"
BACKUP_DIR="$HOME/6ickcleaner-backup"
GITHUB_REPO_URL="https://raw.githubusercontent.com/6ickzone/6ickCleanner/main/version.txt"
SCRIPT_PATH="${BASH_SOURCE[0]}"

# INITIALIZE
DRY_RUN=false
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DELETED_ITEMS=()
TOTAL_FREED=0
START_TIME=$(date +%s)

# LOAD IGNORE LIST
declare -a IGNORE_LIST
if [[ -f "$IGNORE_FILE" ]]; then
  mapfile -t IGNORE_LIST < "$IGNORE_FILE"
fi

# UTILITY FUNCTIONS
confirm() {
  read -rp "$1 [y/N]: " ans
  [[ "$ans" =~ ^[Yy] ]] && return 0 || return 1
}

is_ignored() {
  local name="$1"
  for pattern in "${IGNORE_LIST[@]}"; do
    [[ "$name" == $pattern ]] && return 0
  done
  return 1
}

safe_delete() {
  local target="$1"
  local base=$(basename "$target")
  if is_ignored "$base"; then
    echo "[IGNORED] $target"
  elif $DRY_RUN; then
    echo "[DRY-RUN] would remove: $target"
  else
    local size=$(du -sb "$target" 2>/dev/null | awk '{print $1}')
    rm -rf "$target" && {
      DELETED_ITEMS+=("$target")
      TOTAL_FREED=$((TOTAL_FREED + size))
      echo "[REMOVED] $target"
    }
  fi
}

# CLEAN FUNCTIONS
toggle_dry_run() { DRY_RUN=true; echo "[*] Dry-run activated"; }
clean_pkg_cache()   { echo "[*] Cleaning pkg cache..."; \$DRY_RUN && echo "[DRY-RUN] pkg clean -y" || pkg clean -y; }
clean_pip_cache()   { echo "[*] Cleaning pip cache..."; \$DRY_RUN && echo "[DRY-RUN] pip cache purge" || pip cache purge; }
clean_tmp()         { echo "[*] Cleaning tmp..."; safe_delete "/data/data/com.termux/files/usr/tmp"; }
clean_logs()        { echo "[*] Cleaning logs..."; safe_delete "/data/data/com.termux/files/usr/var/log"; safe_delete "$HOME/storage/logs"; }
clean_large() {
  echo "[*] Scanning >50MB files..."
  while IFS= read -r f; do
    echo "Found: $f"
    confirm "Remove?" && safe_delete "$f"
  done < <(find "$HOME" -type f -size +50M)
}
clean_unused() {
  echo "[*] Detecting unused packages..."
  comm -23 <(pkg list-installed | cut -d/ -f1 | sort) <(grep -oE "\w+" "$HOME/.bash_history" | sort -u) |
  while IFS= read -r p; do
    confirm "Uninstall $p?" && (\$DRY_RUN && echo "[DRY-RUN] pkg uninstall -y $p" || pkg uninstall -y "$p")
  done
}
backup_home() {
  echo "[*] Backing up home..."
  mkdir -p "$BACKUP_DIR"
  local arc="$BACKUP_DIR/$TIMESTAMP.tar.gz"
  \$DRY_RUN && echo "[DRY-RUN] tar czf $arc $HOME" || (tar czf "$arc" "$HOME" && echo "Backup: $arc")
}
clean_android_cache() {
  echo "[*] Cleaning Android cache..."
  command -v termux-cleanup-files &>/dev/null && (\$DRY_RUN && echo "[DRY-RUN] termux-cleanup-files" || termux-cleanup-files)
}
auto_update() {
  echo "[*] Checking updates..."
  local remote=$(curl -fsSL "$GITHUB_REPO_URL")
  local localv="1.1.0"
  if [[ "$remote" != "$localv" ]]; then
    echo "New version: $remote (current: $localv)"
    confirm "Install update?" && curl -fsSL "https://raw.githubusercontent.com/6ickzone/6ickCleanner/main/6ickCleaner.sh" -o "$SCRIPT_PATH" && chmod +x "$SCRIPT_PATH" && echo "Updated. Relaunch." && exit
  else
    echo "Up-to-date ($localv)"
  fi
}

report() {
  echo; echo "===== Summary ====="
  echo "Deleted: ${#DELETED_ITEMS[@]}"
  printf "Freed: %.2f MB\n" "$(bc -l <<< "${TOTAL_FREED}/1048576")"
  echo "Duration: $(( $(date +%s) - START_TIME ))s"; echo "==================="
}

# MENU
main() {
  clear
  cat << 'EOM'
  6ickCleanner v1.1.0
  1) Full Clean
  2) Custom Clean
  3) Dry-Run + Full Clean
  4) Check for Updates
  5) Exit
EOM
  read -rp "Choice [1-5]: " c
  case "$c" in
    1) backup_home; clean_pkg_cache; clean_pip_cache; clean_tmp; clean_logs; clean_large; clean_unused; clean_android_cache; report;;
    2) backup_home; echo "-- Select Tasks --";
       confirm "PKG?" && clean_pkg_cache;
       confirm "PIP?" && clean_pip_cache;
       confirm "TMP?" && clean_tmp;
       confirm "LOGS?" && clean_logs;
       confirm "LARGE?" && clean_large;
       confirm "UNUSED?" && clean_unused;
       confirm "ANDROID?" && clean_android_cache;
       report;;
    3) toggle_dry_run; main;;
    4) auto_update;;
    5) exit;;
    *) echo "Invalid";;
  esac
}

main

