curl -X POST \
     -H 'Content-Type: application/json' \
     -d @<(cat <<EOF
{"chat_id": "$TelegramChatId", "text": "$(hostname) (BASH): Starting installation scirpt..."}
EOF
) https://api.telegram.org/bot$TelegramBotToken/sendMessage

apt purge -y -qq ansible python3 python3-pip
python -m pip install ansible

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

export ANSIBLE_CMD=$(ansible-playbook site.yml -e api_key=$ApiKey -e monitor_user_key=$MonitorUserKey -e telegram_bot_token=$TelegramBotToken -e telegram_chat_id=$TelegramChatId)

curl -X POST \
     -H 'Content-Type: application/json' \
     -d @<(cat <<EOF
{"chat_id": "$TelegramChatId", "text": "$(hostname) (BASH): \n\n $ANSIBLE_CMD"}
EOF
) https://api.telegram.org/bot$TelegramBotToken/sendMessage
