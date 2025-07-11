GPIO_FILE="/sys/kernel/debug/gpio"

val20=$(grep "gpio-20" "$GPIO_FILE" | awk '{print $5}')  # hi / lo
val19=$(grep "gpio-19" "$GPIO_FILE" | awk '{print $5}')  # hi / lo

# Tentukan mode dari kombinasi status
if [ "$val20" = "hi" ] && [ "$val19" = "lo" ]; then
  MODE="Normal Router"
elif [ "$val20" = "lo" ] && [ "$val19" = "hi" ]; then
  MODE="Wifi catcher and share to eth0"
elif [ "$val20" = "hi" ] && [ "$val19" = "hi" ]; then
  MODE="Extender Router"
fi

echo "MR-3040 is in $MODE mode"