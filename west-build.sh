#!/usr/bin/bash

# Accept side parameter: left or right (default: left)
SIDE=${1:-left}

if [[ "$SIDE" != "left" && "$SIDE" != "right" ]]; then
    echo "Error: Side must be 'left' or 'right'"
    echo "Usage: $0 [left|right]"
    exit 1
fi

mkdir -p "/tmp/zmk-config/config"
cp -R config/* "/tmp/zmk-config/config/"
west init -l "/tmp/zmk-config/config"
cd /tmp/zmk-config
west update --fetch-opt=--filter=tree:0
west zephyr-export
build_dir=$(mktemp -d)

if [[ "$SIDE" == "right" ]]; then
    # Build right side without CONFIG_ZMK_STUDIO
    west build -s zmk/app -d $build_dir -b corne_choc_pro_right -S studio-rpc-usb-uart -- -DZMK_CONFIG=/tmp/zmk-config/config -DSHIELD=nice_view -DZMK_EXTRA_MODULES=/zmk-config
else
    # Build left side with CONFIG_ZMK_STUDIO
    west build -s zmk/app -d $build_dir -b "corne_choc_pro_left" -S "studio-rpc-usb-uart" -- -DZMK_CONFIG=/tmp/zmk-config/config -DSHIELD="nice_view" -DZMK_EXTRA_MODULES='/zmk-config' -DCONFIG_ZMK_STUDIO=y
fi

cp $build_dir/zephyr/zmk.uf2 /zmk-config/zmk_${SIDE}.uf2
echo "Build complete: /zmk-config/zmk_${SIDE}.uf2"

