#!/bin/bash
mkdir -p /var/log/clamav/
python3 /opt/auto-clamIPS/notify-clamMA/notify-reset-boot.py
LOGFILE="/var/log/clamav/clamav-found-malware-$(date +'%Y-%m-%d').log";
LOGS_HISTORY="/opt/auto-clamIPS/auto-clamav/logs/logs_history/real-time-history/real-time-history-$(date +'%Y-%m-%d').log";
LOGFILE2="/opt/auto-clamIPS/notify-clamMA/logs/notify.log"
exclude=$(echo $(cat "/opt/auto-clamIPS/auto-clamav/ignore_list.txt"))
option_move=$(echo "")
DIRTOSCAN="/home/"
user=$(echo $(users) | cut -d ' ' -f 1)

### For distributions with non-english languages,get the correct desktop name 
### and convert it to universal(for english and non-english distro)variable
desktop1=$(cat /home/$user/.config/user-dirs.dirs | grep "XDG_DESKTOP_DIR" | cut -d'/' -f2- | tr -d '"')

for S in ${DIRTOSCAN}; do
DIRSIZE=$(du -sh "$S" 2>/dev/null | cut -f1)
echo "Starting a scan of "$S" directory.
Amount of data to be scanned is "$DIRSIZE"."
mkdir -p /home/$(echo $(users) | cut -d ' ' -f 1)/auto-clamIPS/VIRUS-FOUND/
chown -R $(echo $(users) | cut -d ' ' -f 1):$(echo $(users) | cut -d ' ' -f 1) /home/$(echo $(users) | cut -d ' ' -f 1)/auto-clamIPS/
clamscan --infected --recursive --exclude=/home/$user/auto-clamIPS/VIRUS-FOUND/ --exclude=/home/$user/.local/share/Trash/files/ --exclude=/home/$user/$desktop1/clamav-found-malware-$(date +"%Y-%m-%d").log $exclude $option_move "$S" >> "$LOGFILE"
zip -m -j /home/$(echo $(users) | cut -d ' ' -f 1)/auto-clamIPS/VIRUS-FOUND/VIRUS-FOUND.zip /home/$(echo $(users) | cut -d ' ' -f 1)/auto-clamIPS/VIRUS-FOUND/* 1> /dev/null
mkdir -p /opt/auto-clamIPS/auto-clamav/logs/logs_history/real-time-history/
cat "$LOGFILE" >> "$LOGS_HISTORY"
cat "$LOGFILE" >> "$LOGFILE2"
# get the value of "Infected lines"
MALWARE=$(tail "$LOGFILE"|grep Infected|cut -d" " -f3)
# 
if [ "$MALWARE" -ne "0" ];then
# using file below

cat "$LOGFILE" >> "$LOGS_HISTORY"
cat "$LOGFILE" >> "$LOGFILE2"
cat $LOGFILE >> "/home/$user/$desktop1/clamav-found-malware-$(date +'%Y-%m-%d').log"
cat $LOGFILE >> /root/clamav-found-malware-$(date +'%Y-%m-%d').log


fi

done
exit 0
