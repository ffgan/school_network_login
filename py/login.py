import requests as req
import time
import random as r


YunYingShang = "cmcc"  # 选自己的运营商，中国移动 cmcc 中国电信 telecom  中国联通 unicom 校园网目测是个空串
passwd = "xxx"  # 登陆密码，改成自己的
xh = "xxx"  # 学号，改成自己的
ses = req.session()
ses.get("http://10.2.5.251/")

time_stamp = str(time.time_ns())[:13]

txt = ses.get(
    f"http://10.2.5.251/drcom/chkstatus?callback=dr{time_stamp}&v={r.randint(500, 10000)}"
).text
#  这个callback是这样的 var callbackName = 'dr' + (new Date()).getTime(); // 自定义 callbackName 以这个值举例 1686919598143 ，可以用time库 ,后面那个v是个随机数，用random

ip = txt[txt.index("ss5") + 6 : txt.index("ss6") - 3]

a = ses.get(
    f"http://10.2.5.251:801/eportal/?c=Portal&a=login&callback=dr{str(time.time_ns())[:13]}&login_method=1&user_account={xh}%40{YunYingShang}&user_password={passwd}&wlan_user_ip={ip}&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.0&_={str(time.time_ns())[:13]}"
)
print(
    a.text
)  # dr1686920999059({"result":"1","msg":"认证成功"})  这个result为1即为登陆成功
