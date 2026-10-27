#!/usr/bin/env bash
# Ajustes no projeto Android gerado pelo Capacitor: permissões dos lembretes e número da versão.
set -euo pipefail
M=android/app/src/main/AndroidManifest.xml
sed -i 's#<application#<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />\n    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />\n    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" android:maxSdkVersion="32" />\n    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />\n\n    <application#' "$M"
G=android/app/build.gradle
sed -i -E "s/versionCode [0-9]+/versionCode ${BUILD:-1}/; s/versionName \"[^\"]+\"/versionName \"${VERSION:-1.0}\"/" "$G"
grep -n "versionCode\|versionName" "$G"
grep -n "uses-permission" "$M"
