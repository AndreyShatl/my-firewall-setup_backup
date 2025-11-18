🛡️ My Firewall Setup
Полная система обхода блокировок на базе Zapret + WireGuard + NFTables

📁 Структура проекта
text
/opt/my-firewall-setup/
├── 📂 bin/                    # Основные исполняемые файлы
│   └── my-firewall           # Главный скрипт управления
├── 📂 etc/                    # Конфигурации
│   ├── nftables/             # Правила NFTables
│   └── wireguard/            # Конфиги WireGuard
├── 📂 scripts/               # Скрипты управления
│   ├── firewall-manager.sh   # Менеджер фаервола
│   ├── manage-services.sh    # Управление сервисами
│   └── wireguard/            # Скрипты WireGuard
├── 📂 systemd/               # Systemd сервисы
│   └── services/             # Сервисы Zapret
└── 📂 zapret/                # Zapret бинарники и настройки
    ├── binaries/my/nfqws     # Бинарник nfqws
    └── ipset/                # Списки хостов
🚀 Быстрый старт
Установка и настройка
bash
# Клонировать репозиторий
git clone <repository-url>
cd my-firewall-setup

# Дать права на выполнение
chmod +x bin/my-firewall scripts/*.sh

# Развернуть systemd сервисы
cp systemd/services/*.service /etc/systemd/system/
systemctl daemon-reload
Первый запуск
bash
# Запустить все сервисы
./scripts/manage-services.sh start

# Включить автозагрузку
systemctl enable zapret-youtube-tcp zapret-youtube-udp \
                 zapret-instagram-tcp zapret-instagram-udp \
                 zapret-discord-tcp zapret-discord-udp
🎮 Команды управления
🔄 Управление всеми сервисами Zapret
bash
# Статус всех сервисов
./scripts/manage-services.sh status

# Запуск всех сервисов
./scripts/manage-services.sh start

# Остановка всех сервисов
./scripts/manage-services.sh stop

# Перезапуск всех сервисов
./scripts/manage-services.sh restart
🛡️ Управление фаерволом (полный контроль)
bash
# Полный статус системы
./bin/my-firewall status

# Перезагрузить правила NFTables
./bin/my-firewall reload

# Показать правила NFTables
./bin/my-firewall show-rules

# Проверить конфигурацию
./bin/my-firewall validate
📊 Мониторинг системы
bash
# Проверить процессы nfqws
ps aux | grep nfqws | grep -v grep

# Посмотреть логи сервисов
journalctl -u zapret-youtube-tcp -f
journalctl -u zapret-youtube-udp -f

# Статус WireGuard
wg show

# Проверить NFTables
nft list tables
nft list table inet traffic_shaping
⚡ Systemd сервисы (индивидуальное управление)
bash
# YouTube TCP
systemctl status zapret-youtube-tcp
systemctl restart zapret-youtube-tcp

# YouTube UDP  
systemctl status zapret-youtube-udp
systemctl restart zapret-youtube-udp

# Instagram TCP
systemctl status zapret-instagram-tcp
systemctl restart zapret-instagram-tcp

# Instagram UDP
systemctl status zapret-instagram-udp  
systemctl restart zapret-instagram-udp

# Discord TCP
systemctl status zapret-discord-tcp
systemctl restart zapret-discord-tcp

# Discord UDP
systemctl status zapret-discord-udp
systemctl restart zapret-discord-udp
🔧 Администрирование WireGuard
bash
# Статус WireGuard
systemctl status wg-quick@wg0

# Перезапуск WireGuard
systemctl restart wg-quick@wg0

# Добавление клиента
./scripts/wireguard/add-client.sh <client_name>

# Удаление клиента  
./scripts/wireguard/remove-client.sh <client_name>

# Показать QR код
./scripts/wireguard/show-qr.sh <client_name>
🎯 Очереди NFTables
Сервисы используют следующие очереди:

200 - YouTube TCP (порты 80, 443)

201 - YouTube UDP (порты 80, 443, 19302-19309)

202 - Instagram TCP (порты 80, 443)

203 - Instagram UDP (порты 80, 443)

204 - Discord TCP (порты 80, 443)

205 - Discord UDP (порты 80, 443, 3478-3481)

📈 Статистика хостов
bash
# Показать количество доменов в списках
./bin/my-firewall status | grep -A5 "Hostlist Counts"
🆘 Аварийное восстановление
Если сервисы не запускаются
bash
# Принудительно убить все процессы nfqws
sudo pkill -f nfqws

# Перезапустить сервисы
./scripts/manage-services.sh restart
Если NFTables сломан
bash
# Сбросить правила
nft flush ruleset

# Восстановить правила
./bin/my-firewall reload
Если WireGuard не работает
bash
# Перезапустить интерфейс
wg-quick down wg0
wg-quick up wg0
🔄 Обновление проекта
bash
# Обновить из репозитория
git pull origin main

# Перезапустить сервисы с новой конфигурацией
./scripts/manage-services.sh restart
./bin/my-firewall reload
📞 Логи и диагностика
bash
# Все логи Zapret
journalctl -u zapret-* --since "1 hour ago"

# Логи конкретного сервиса
journalctl -u zapret-youtube-tcp -f

# Проверить системные логи
journalctl -b | grep -i zapret

# Мониторинг в реальном времени
htop -p $(pgrep -d',' -f "nfqws")
💡 Совет: Для удобства добавьте алиасы в ~/.bashrc:

bash
alias fw-status='/opt/my-firewall-setup/bin/my-firewall status'
alias fw-restart='/opt/my-firewall-setup/scripts/manage-services.sh restart'
alias fw-logs='journalctl -u zapret-* -f'
