# Fedora on Bmax-y11-plus
Linux scripts and config files for Fedora Linux on Bmax Y11 Plus

## Tablet mode
This section is describing how to autorotate screen with disabling keyboard and toushpad when laptopt is in tablet mode.

**1. Install evtest**
   
   It is required by systemd service disable-phisical-keyboard
   ```
   sudo dnf -y install evtest
   ```
**2. Systemd service**

   copy usr/lib/systemd/system/disable-physical-keyboard.service file to /usr/lib/systemd/system/ directory
   Reload the service files to include the new service
   ```
   sudo systemctl daemon-reload
   ```
**3. Permissions**

   Make sure your desktop user belongs to wheel group and add following line to /etc/sudoers file:
   ```
   %wheel	ALL=(ALL)	NOPASSWD: /usr/bin/systemctl start disable-physical-keyboard.service, /usr/bin/systemctl stop disable-physical-keyboard.service
   ```
**4. Scripts**

   Copy usr/local/sbin/gnome-randr.py and usr/local/sbin/tablet-mode-detector.sh files to /usr/local/sbin/ directory. Change scripts permissions to executable.
   
**5. Autostart**

   Copy etc/xdg/autostart/tablet-mode-detector.desktop file to /etc/xdg/autostart/ directory

## Google drive
This section is describing how to automatically mount google drives

**1. Create directories for mounting google drives**

   Create directories using covention /mnt/gdrive/<google account name>
   
**2. Install google-drive-ocamlfuse**

   Copy etc/yum.repos.d/google-drive-ocamlfuse.repo to /etc/yum.repos.d/ directory and install google-drive-ocamlfuse
   ```
   sudo dnf -y install google-drive-ocamlfuse
   ```

**3. Authenticate to google accounts**

   Run command
   ```
   google-drive-ocamlfuse -label <google account name>
   ```

**4. Script**

   Copy usr/local/sbin/google-drive-mount.sh to /usr/local/sbin/ directory. Change scripts permissions to executable.

**5. Autostart**

   Copy etc/xdg/autostart/google-drive-ocamlfuse.desktop to /etc/xdg/autostart/ directory
