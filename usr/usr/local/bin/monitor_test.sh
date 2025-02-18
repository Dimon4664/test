#!/bin/bash

# Лог-файл
LOG_FILE="/var/log/monitoring.log"

# Имя процесса
PROCESS_NAME="test"

# URL для мониторинга
MONITORING_URL="https://test.com/monitoring/test/api"

# Функция для записи в лог
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Проверка, запущен ли процесс
if pgrep -x "$PROCESS_NAME" > /dev/null; then
    # Если процесс запущен, отправляем HTTP-запрос
    if curl -s -o /dev/null -w "%{http_code}" "$MONITORING_URL" | grep -q "200"; then
        log_message "Процесс $PROCESS_NAME запущен и сервер мониторинга доступен."
    else
        log_message "Сервер мониторинга недоступен."
    fi
else
    # Если процесс не запущен, проверяем, был ли он запущен ранее
    if [ -f /tmp/${PROCESS_NAME}_running ]; then
        log_message "Процесс $PROCESS_NAME был перезапущен."
        rm /tmp/${PROCESS_NAME}_running
    fi
fi

# Создаем временный файл, если процесс запущен
if pgrep -x "$PROCESS_NAME" > /dev/null; then
    touch /tmp/${PROCESS_NAME}_running
fi
