#!/bin/sh

GPIO_FILE="/sys/kernel/debug/gpio"
LAST_MODE=0
STABLE_COUNT=0
BOUNCE_LIMIT=20

NORMAL="/root/eth_to_wifiap.sh"
RELAY="/root/extender.sh"
WIFISTA="/root/wifista_to_eth.sh"

switch_mode() {
  val20=$(grep "gpio-20" "$GPIO_FILE" | awk '{print $5}')  # hi / lo
    val19=$(grep "gpio-19" "$GPIO_FILE" | awk '{print $5}')  # hi / lo

    # Tentukan mode dari kombinasi status
    if [ "$val20" = "hi" ] && [ "$val19" = "lo" ]; then
      MODE=0
      RUN=$NORMAL
    elif [ "$val20" = "lo" ] && [ "$val19" = "hi" ]; then
      MODE=1
      RUN=$WIFISTA
    elif [ "$val20" = "hi" ] && [ "$val19" = "hi" ]; then
      MODE=2
      #RUN=$RELAY
    fi
    return $MODE
}


while true; do
  while $STATUS; do
    switch_mode
    MODE=$?
    # Deteksi stabilitas sinyal (debounce)
    if [ "$MODE" = "$LAST_MODE" ]; then
      STABLE_COUNT=0  # Reset jika sama dengan mode terakhir
    else
      STABLE_COUNT=$((STABLE_COUNT + 1))
    fi
    # Kalau mode sudah stabil selama beberapa bacaan berturut-turut
    if [ "$STABLE_COUNT" -ge "$BOUNCE_LIMIT" ]; then
      echo "[✓] Mode stabil terdeteksi: $MODE (gpio-20=$val20, gpio-19=$val19)"
      STABLE_COUNT=0
      STATUS=false
      sh "$RUN"
    fi
  done
  
  if [ "$MODE" -ne "$LAST_MODE" ]; then
    LAST_MODE="$MODE"
    STATUS=true
  fi
    
done
