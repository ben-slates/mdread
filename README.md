# mdread -- Modern CLI Markdown Reader

Fast, clean, interactive terminal Markdown reader with one-click command copying.

---

## Quick Installation

### Single One-Line Install:
```bash
unzip -q -o ~/Desktop/mdread.zip -d ~/Desktop/ && cd ~/Desktop/mdread && ./install.sh
```

---

## Clean Command Copying

When viewing Markdown files in standard CLI tools, selecting commands with a mouse copies box borders, indentation, and extra spaces, breaking the command when pasted into a new shell.

mdread solves this with two fast options:

### 1. Interactive Reader with Clickable [COPY] Button
Open any file:
```bash
mdread README.md
```
* Fast loading with no side palette or clutter.
* Every code block has a clear, high-contrast [COPY] button in the top right.
* Click it with the mouse (or navigate to it) to copy the clean command to your system clipboard (Wayland, X11, OSC 52).
* Paste cleanly into any terminal (Ctrl+V or Ctrl+Shift+V).
* Press 'q' to quit.

---

### 2. Fast Command Picker Mode (-c / --copy)
Quickly grab any command without scrolling the document:
```bash
mdread -c README.md
```
Lists all command blocks with numbers [1], [2], [3]. Type the number and hit Enter to copy directly to clipboard.

---

### 3. Direct Print Mode
```bash
mdread --no-pager README.md
```

---

## Uninstallation

To remove user install:
```bash
./uninstall.sh
```

To remove system-wide install:
```bash
sudo ./uninstall.sh
```
