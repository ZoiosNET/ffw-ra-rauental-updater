if [ "$EUID" -ne 0 ]
  then echo "Bitte als root ausführen!"
  exit
fi

cd /opt

echo "Bitte geben sie den API-Key ein:"
read tmpApiKey
export ApiKey="$tmpApiKey"
echo "ApiKey=\"$tmpApiKey\"" >> /etc/environment

echo "Bitte geben sie den Monitor-User-Key ein:"
read tmpMonitorUserKey
export MonitorUserKey="$tmpMonitorUserKey"
echo "MonitorUserKey=\"$tmpMonitorUserKey\"" >> /etc/environment

echo "Bitte geben sie den System-User-Key ein:"
read tmpSystemUserKey
export SystemUserKey="$tmpSystemUserKey"
echo "SystemUserKey=\"$tmpSystemUserKey\"" >> /etc/environment

echo "Bitte geben sie die Telegram-Bot-Token ein:"
read tmpTelegramBotToken
export TelegramBotToken="$tmpTelegramBotToken"
echo "TelegramBotToken=\"$tmpTelegramBotToken\"" >> /etc/environment

echo "Bitte geben sie die Telegram-Chat-Id ein:"
read tmpTelegramChatId
export TelegramChatId="$tmpTelegramChatId"
echo "TelegramChatId=\"$tmpTelegramChatId\"" >> /etc/environment

apt install git python3 python3-pip -y
python3 -m pip install ansible
git clone https://github.com/ZoiosNET/ffw-ra-rauental-updater.git

cd ffw-ra-rauental-updater
chmod 755 update.sh
./update.sh

echo "reboot..."
reboot
