本项目主要实现了矿大校园网的登陆
```

$ sudo cp login.service  /etc/systemd/system/login.service

$ systemctl start login // 测试能否运行

$ systemctl enable login  // 添加开机自启，输出结果如下

Created symlink /etc/systemd/system/multi-user.target.wants/login.service → /etc/systemd/system/login.service.

```
