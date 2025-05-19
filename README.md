![6ickCleanner Logo](https://raw.githubusercontent.com/6ickzone/6ickCleanner.sh/refs/heads/main/file_00000000cf1861f88c28b3e2bff941ba.png)

# 6ickCleanner

**6ickCleanner** — A lightweight cleanup tool for Termux, infused with hacker-style vibes by 0x6ick.  
Optimize storage, clear caches, detect large files, and auto-update directly from GitHub.

> Made with ✦ by [0x6ick](https://github.com/6ickzone)

---

## ✦ Key Features

- Clean **pkg cache**, **pip cache**, **tmp**, and **log** directories  
- Scan and remove large files (>50MB)  
- Detect rarely used packages (inactive for 30 days)  
- Automatic backup before cleanup  
- **Dry-run mode** (simulate cleanup without deleting files)  
- Auto-update directly from GitHub  

---

## ✦ Installation

```bash
# Navigate to ~/bin and download the script
mkdir -p ~/bin
cd ~/bin
curl -O https://raw.githubusercontent.com/6ickzone/6ickCleanner.sh/refs/heads/main/6ickCleanner.sh
chmod +x 6ickCleanner.sh

# Run the script
~/bin/6ickCleanner.sh

# ✦ Optional: Add ~/bin to your PATH in .bashrc or .profile

---

✦ Usage

Run the script and choose from the menu:

1. Full Clean
2. Custom Clean
3. Dry Run + Full Clean
4. Check for Updates
5. Exit

Full Clean: Performs a complete cleanup automatically

Custom Clean: Allows manual selection of items to clean

Dry Run: Safe simulation without deleting any data


---

✦ Ignore List

To skip specific files or folders during cleanup, create a file at:
~/.6ickcleaner-ignore
Example content:
Downloads  
important.docx

---

✦ Updating the Script

Use menu option 4 to check for updates.
If a new version is available, it will be downloaded and installed automatically.


---

✦ Credits

Author: 0x6ick
Repository: 6ickCleanner

---

✦ License

This project is licensed under the MIT License.
---
