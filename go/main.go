package main

import (
	"fmt"
	"io"
	"math/rand"
	"net/http"
	"strconv"
	"strings"
	"time"
)

var YunYingShang = "cmcc" // 选自己的运营商，中国移动 cmcc 中国电信 telecom 中国联通 unicom 校园网目测是个空串
var passwd = "xxx"
var xh = "xxx"

func login() []byte {
	time_stamp := strconv.FormatInt(time.Now().UnixNano()/1000000, 10)[:13]

	resp, err := http.Get(fmt.Sprintf("http://10.2.5.251/drcom/chkstatus?callback=dr%s&v=%d", time_stamp, rand.Intn(9500)+500))
	if err != nil {
		return nil
	}
	body, _ := io.ReadAll(resp.Body)
	resp.Body.Close()
	txt := string(body)
	ip := txt[strings.Index(txt, "ss5")+6 : strings.Index(txt, "ss6")-3]

	resp, err = http.Get(fmt.Sprintf("http://10.2.5.251:801/eportal/?c=Portal&a=login&callback=dr%s&login_method=1&user_account=%s@%s&user_password=%s&wlan_user_ip=%s&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.0&_=%s",
		time_stamp, xh, YunYingShang, passwd, ip, time_stamp))
	if err != nil {
		return nil
	}
	body, _ = io.ReadAll(resp.Body)
	resp.Body.Close()
	return body // dr1686920999059({"result":"1","msg":"认证成功"}) 这个result为1即为登陆成功
}

func hello(w http.ResponseWriter, _ *http.Request) {
	w.Write(login())
}
func main() {
	http.HandleFunc("/", hello)
	http.ListenAndServe("0.0.0.0:4431", nil)
}
