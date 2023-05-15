curl -X POST \
     -H 'Content-Type: application/json' \
     -d @<(cat <<EOF
{"chat_id": "$TelegramChatId", "text": "$(hostname): Starting installation scirpt..."}
EOF
) https://api.telegram.org/bot$TelegramBotToken/sendMessage

apt purge -y -qq ansible
apt install -y -qq python3 python3-pip git git-lfs
python3 -m pip install ansible

git checkout -- .
git pull
rm -rf external_roles
ansible-galaxy install --force -r requirements.yml

ansible-playbook site.yml -e api_key=$ApiKey -e monitor_user_key=$MonitorUserKey -e system_user_key=$SystemUserKey -e telegram_bot_token=$TelegramBotToken -e telegram_chat_id=$TelegramChatId

curl -X POST \
     -H 'Content-Type: application/json' \
     -d @<(cat <<EOF
{"chat_id": "$TelegramChatId", "text": "$(hostname): Installation script finished!"}
EOF
) https://api.telegram.org/bot$TelegramBotToken/sendMessage

journalctl -u display-updater >> /tmp/display-updater.txt
curl -F "chat_id=$TelegramChatId" -F document=@/tmp/display-updater.txt https://api.telegram.org/bot$TelegramBotToken/sendDocument

echo ".Xauthority:" >> /tmp/infos.txt
ls -lah /home/pi/.Xauthority >> /tmp/infos.txt
echo "uname:" >> /tmp/infos.txt
uname -m >> /tmp/infos.txt
echo "dpkg-architecture:" >> /tmp/infos.txt
dpkg --print-architecture >> /tmp/infos.txt
curl -F "chat_id=$TelegramChatId" -F document=@/tmp/infos.txt https://api.telegram.org/bot$TelegramBotToken/sendDocument
