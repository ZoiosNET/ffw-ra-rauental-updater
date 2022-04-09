if [ "$EUID" -ne 0 ]
  then echo "Bitte als root ausführen!"
  exit
fi

cd /opt

echo "Bitte geben sie den API-Key ein:"
read tmpApiKey

export ApiKey="$tmpApiKey"
echo "ApiKey=$tmpApiKey" >> /etc/environment

echo "Bitte geben sie die Telegram-Chat-Id ein:"
read tmpTelegramChatId

export TelegramChatId="$tmpTelegramChatId"
echo "TelegramChatId=$tmpTelegramChatId" >> /etc/environment

apt install git ansible -y
git clone https://github.com/ZoiosNET/ffw-ra-rauental-updater.git

cd ffw-ra-rauental-updater
chmod 755 update.sh
./update.sh
