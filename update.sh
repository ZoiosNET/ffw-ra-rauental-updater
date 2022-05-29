git checkout -- .
git pull
rm -rf external_roles
ansible-galaxy install -r requirements.yml
ansible-playbook site.yml -e api_key=$ApiKey -e monitor_user_key=$MonitorUserKey -e telegram_bot_token=$TelegramBotToken -e telegram_chat_id=$TelegramChatId
