#!/usr/bin/bash
mkdir -p "/tmp/zmk-config/config"
cp -R config/* "/tmp/zmk-config/config/"
west init -l "/tmp/zmk-config/config"
cd /tmp/zmk-config
west update --fetch-opt=--filter=tree:0
west zephyr-export
build_dir=$(mktemp -d)
west build -s zmk/app -d $build_dir -b "corne_choc_pro_left" -S "studio-rpc-usb-uart" -- -DZMK_CONFIG=/tmp/zmk-config/config -DSHIELD="nice_view" -DZMK_EXTRA_MODULES='/zmk-config' -DCONFIG_ZMK_STUDIO=y
cp $build_dir/zephyr/zmk.uf2 /zmk-config/zmk.uf2

