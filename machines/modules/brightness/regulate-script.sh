IN_DEV="iio:device0"
OUT_DEV="amdgpu_bl1"

HI_IN=172
HI_OUT=70

LO_IN=45
LO_OUT=20

MIN_BR=5
USER_MAX_BR=256

ILLUM_FILE="/sys/bus/iio/devices/$IN_DEV/in_illuminance_raw"
BR_FILE="/sys/class/backlight/$OUT_DEV/brightness"
MAX_BR_FILE="/sys/class/backlight/$OUT_DEV/max_brightness"

while true; do
	A=$((HI_IN-LO_IN))
	I=$(cat $ILLUM_FILE)
	MAX_BR=$(cat $MAX_BR_FILE)
	BR=$(((I-LO_IN)*(HI_OUT-LO_OUT)/A+LO_OUT))
	BR=$((BR>MAX_BR?MAX_BR:BR))
	BR=$((BR>USER_MAX_BR?USER_MAX_BR:BR))
	BR=$((BR<MIN_BR?MIN_BR:BR))
	echo $BR > "$BR_FILE"
	sleep 1
done
