файлы расположены согласно целевой структуре, необходимые действия:
chmod +x /usr/local/bin/monitor_test.sh
systemctl enable monitor_test.timer
systemctl start monitor_test.timer
