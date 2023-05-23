curl -X POST \
     -H 'Content-Type: application/json' \
     -d @<(cat <<EOF
{"chat_id": "$TelegramChatId", "text": "$(hostname): Starting installation scirpt..."}
EOF
) https://api.telegram.org/bot$TelegramBotToken/sendMessage

apt purge -y -qq ansible
apt install -y -qq python3 python3-pip git git-lfs
python3 -m pip install ansible

git config --global pull.rebase true
git config --global fetch.prune true
git checkout -- .
git pull
rm -rf external_roles
ansible-galaxy install -r requirements.yml

ansible-playbook site.yml -e api_key=$ApiKey -e monitor_user_key=$MonitorUserKey -e system_user_key=$SystemUserKey -e telegram_bot_token=$TelegramBotToken -e telegram_chat_id=$TelegramChatId

curl -X POST \
     -H 'Content-Type: application/json' \
     -d @<(cat <<EOF
{"chat_id": "$TelegramChatId", "text": "$(hostname): Installation script finished!"}
EOF
) https://api.telegram.org/bot$TelegramBotToken/sendMessage

journalctl -u display-updater >> /tmp/display-updater.txt
curl -F "chat_id=$TelegramChatId" -F document=@/tmp/display-updater.txt https://api.telegram.org/bot$TelegramBotToken/sendDocument

cat /home/pi/.local/share/xorg/Xorg.0.log >> /tmp/xorg.txt
curl -F "chat_id=$TelegramChatId" -F document=@/tmp/xorg.txt https://api.telegram.org/bot$TelegramBotToken/sendDocument

yes | rpi-update
