#!/bin/sh

# 基本参照本项目里的Python脚本来写的，只需要安装好wget就行，默认发行版都会带wget
# 对于刷了openwrt的路由器，cron加一下每天7点执行该脚本即可，可参考 0 7 * * * /root/login.sh


# 选自己的运营商，中国移动 cmcc 中国电信 telecom 中国联通 unicom 校园网目测是个空串
YunYingShang="cmcc"
# 学号，改成自己的
xh="xxx"
# 登陆密码，改成自己的
passwd="xxx"

PORTAL_BASE_URL="http://10.2.5.251"
LOGIN_PATH_PORT="http://10.2.5.251:801/eportal/"

time_stamp=$(date +%s%N | cut -b 1-13)

v_random=$(($RANDOM % 9501 + 500)) # 10000 - 500 + 1 = 9501

echo "Fetching status and IP (callback=dr${time_stamp}&v=${v_random})..."

chkstatus_url="${PORTAL_BASE_URL}/drcom/chkstatus?callback=dr${time_stamp}&v=${v_random}"
chkstatus_txt=$(wget --quiet -O - "$chkstatus_url")

if [ $? -ne 0 ]; then
    echo "Error: Failed to get status response."
    exit 1
fi

if [ -z "$chkstatus_txt" ]; then
    echo "Error: Status response was empty."
    exit 1
fi

ip=$(echo "$chkstatus_txt" | sed -n 's/.*"ss5":"\([^"]*\)".*/\1/p')
echo $ip

if [ -z "$ip" ]; then
    echo "Error: Could not extract IP address from status response."
    echo "Response was: $chkstatus_txt"
    if echo "$chkstatus_txt" | grep -q '"result":"1"'; then
        echo "Status indicates already logged in."
    fi
    exit 1
fi

echo "Extracted IP: $ip"

login_timestamp=$(date +%s%N | cut -b 1-13)

echo "Attempting login (user=${xh}@${YunYingShang}, ip=${ip})..."

login_url="${LOGIN_PATH_PORT}?c=Portal&a=login&callback=dr${login_timestamp}&login_method=1&user_account=${xh}%40${YunYingShang}&user_password=${passwd}&wlan_user_ip=${ip}&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.0&_=${login_timestamp}"

echo "Login Response:"
login_response=$(wget --quiet -O - "$login_url")

echo "$login_response"

if [ $? -ne 0 ]; then
    echo "Error: Login request failed."
fi

if echo "$login_response" | grep -q '"result":"1"'; then
    echo "Login successful."
elif echo "$login_response" | grep -q '"result":"0"'; then
    echo "Login failed (result 0). See response for details."
else
    echo "Login result unknown. See response for details."
fi

exit 0
