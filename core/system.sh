#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Termux Bootstrap System Detector
# Core Module
# =====================================


get_arch(){

    uname -m

}


get_kernel(){

    uname -r

}


get_android_version(){

    getprop ro.build.version.release

}


get_device(){

    getprop ro.product.model

}


get_manufacturer(){

    getprop ro.product.manufacturer

}


get_ram(){

    if command -v free >/dev/null 2>&1
    then
        free -h | awk '/Mem:/ {print $2}'
    else
        echo "unknown"
    fi

}


get_storage(){

    df -h "$HOME" | awk 'NR==2 {print $4}'

}


is_termux(){

    if [ -n "$PREFIX" ] && [ -d "$PREFIX" ]
    then
        return 0
    else
        return 1
    fi

}


system_summary(){

    echo "=============================="
    echo " TERMUX BOOTSTRAP SYSTEM"
    echo "=============================="

    echo "Device: $(get_device)"
    echo "Manufacturer: $(get_manufacturer)"
    echo "Android: $(get_android_version)"
    echo "Architecture: $(get_arch)"
    echo "Kernel: $(get_kernel)"
    echo "RAM: $(get_ram)"
    echo "Storage free: $(get_storage)"

}
