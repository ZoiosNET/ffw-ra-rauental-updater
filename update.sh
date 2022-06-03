curl -X POST \
     -H 'Content-Type: application/json' \
     -d @<(cat <<EOF
{"chat_id": "$TelegramChatId", "text": "$(hostname) (BASH): Starting installation scirpt..."}
EOF
) https://api.telegram.org/bot$TelegramBotToken/sendMessage

apt purge -y -qq ansible
apt install -y -qq python3 python3-pip
python3 -m pip install ansible

curl -X POST \
     -H 'Content-Type: application/json' \
     -d @<(cat <<EOF
{"chat_id": "$TelegramChatId", "text": "$(hostname) (BASH): Updating installation scirpt..."}
EOF
) https://api.telegram.org/bot$TelegramBotToken/sendMessage

git checkout -- .
git pull
rm -rf external_roles
ansible-galaxy install -r requirements.yml

curl -X POST \
     -H 'Content-Type: application/json' \
     -d @<(cat <<EOF
{"chat_id": "$TelegramChatId", "text": "$(hostname) (BASH): Start Ansible to install display-software..."}
EOF
) https://api.telegram.org/bot$TelegramBotToken/sendMessage

ansible-playbook site.yml -e api_key=$ApiKey -e monitor_user_key=$MonitorUserKey -e telegram_bot_token=$TelegramBotToken -e telegram_chat_id=$TelegramChatId

curl -X POST \
     -H 'Content-Type: application/json' \
     -d @<(cat <<EOF
{"chat_id": "$TelegramChatId", "text": "$(hostname) (BASH): Finished!"}
EOF
) https://api.telegram.org/bot$TelegramBotToken/sendMessage
