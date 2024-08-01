scp school_network op:/root
scp school op:/etc/init.d/
ssh op chmod +x /etc/init.d/school
ssh op /etc/init.d/school start
ssh op /etc/init.d/school enable
