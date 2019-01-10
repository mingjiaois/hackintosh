


echo "----------------------------"   
echo "检查系统补丁"   
OS=`uname -a`
echo "系统版本情况为${OS}"   



echo "----**用户账号配置**----"   
echo "检查是否存在无用账号"   
passwd=`ls -l /etc/passwd | awk '{print $1}'`
if [ "${passwd:1:9}" = "rw-r--r--" ]; then
    echo "/etc/passwd文件权限为644，符合规范"   
else
    echo "/etc/passwd文件权限为${passwd:1:9}，不符合规范"   
fi
PASSWD_U=`cat /etc/passwd | awk -F[:] '{print $1}'`
echo "查看是否存在无用账号：${PASSWD_U}"   

    
echo "----------------------------"       
echo "检查不同用户是否共享账号"       
PASS=`cat /etc/passwd | awk -F[:] '{print $1}'`
echo "cat /etc/passwd结果为${PASS}"   
#查看所有账号，与管理员确认是否有共享账号    
    
echo "----------------------------"   
echo "检查是否删除或锁定无用账号"   
NOlogin=`cat /etc/passwd | grep nologin | awk -F[:] '{print $1}'`
echo "shell域中为nologin的账户有${NOlogin}"   

    
echo "----------------------------"       
echo "检查是否存在无用用户组"   
GROUP=`ls -l /etc/group | awk '{print $1}'`
echo "/etc/group文件权限为${GROUP}"   
GROUP_U=`cat /etc/group | awk -F[:] '{print $1}'`
echo "/etc/group用户组有${GROUP}"   

    
echo "----------------------------"       
echo "检查是否指定用户组成员使用su命令"   
if [ -e /etc/pam.d/su ];then
    SUFFI=`cat /etc/pam.d/su | grep auth | grep sufficient | grep pam_rootok.so`
    REQUIRED=`cat /etc/pam.d/su | grep auth | grep required | grep group=`
    echo "是否指定用户组成员情况为${SUFFI}\n${REQUIRED}"   
else
    echo "未找到/etc/pam.d/su配置文件"   
fi

echo "检查是否禁Ping"   
Pingstatus=`cat /proc/sys/net/ipv4/icmp_echo_ignore_all `
if [ $Pingstatus -eq 0 ];then
    echo "允许ping"   
else [ $? -eq 3 ]
    echo "禁止ping"   
fi

echo "检查send_redirects符合"   
Send=`cat /proc/sys/net/ipv4/conf/all/send_redirects `
if [ $Send -eq 0 ];then
    echo "send_redirects符合"   
else [ $? -eq 3 ]
    echo "不符合建议修改0"   
fi

Ipforward=`cat /proc/sys/net/ipv4/ip_forward`
if [ $Send -eq 0 ];then
    echo "ip_forward符合"   
else [ $? -eq 3 ]
    echo "不符合建议修改0"   
fi
echo "检查passwd group文件安全权限"   


lsattr /etc/group | grep i
if [ "$?" == 0 ]; then
    echo "/etc/group文件存在i属性文件"   
else
    echo "/etc/group文件不存在i文件属性"   
fi
lsattr /etc/passwd | grep i
if [ "$?" == 0  ]; then
    echo "/etc/passwd存在i属性文件"   
else
    echo "/etc/passwd不存在i文件属性"   
fi
lsattr /etc/shadow | grep i
if [ "$?" == 0 ]; then
    echo "/etc/shadow文件存在i属性文件"   
else
    echo "/etc/shadow文件不存在i文件属性"   
fi
lsattr /etc/gshadow | grep i`
if [ "$?" == 0 ]; then
    echo "/etc/gshadow文件存在i属性文件"   
else
    echo "/etc/gshadow文件不存在i文件属性"   
fi



echo "重要文件权限检查中..."
file1=`ls -l /etc/passwd | awk '{print $1}'`
if [ $file1 == "-rw-r--r--." ];then
  echo " [ √ ] /etc/passwd文件权限为644，符合要求"   
else
  echo " [ X ] /etc/passwd文件权限为[$file1.],不符合要求"   
fi

file2=`ls -l /etc/shadow | awk '{print $1}'`
if [ $file2 == "-rw-r--r--." ] || [ $file2 = "----------." ];then
  echo " [ √ ] /etc/shadow文件权限为400或000，符合要求"   
else
  echo " [ X ] /etc/shadow文件权限为${file2},不符合要求"   
fi

file3=`ls -l /etc/group | awk '{print $1}'`
if [ $file3 == "-rw-r--r--." ];then
  echo " [ √ ] /etc/group文件权限为644，符合要求"   
else
  echo " [ X ] /etc/group文件权限为$file3，不符合要求"   
fi

file4=`ls -l /etc/securetty | awk '{print $1}'`
if [ $file4 == "-rw-------." ];then
  echo " [ √ ] /etc/security文件权限为600，符合要求"   
else
  echo " [ X ] /etc/security文件权限不为600，不符合要求，建议设置权限为600"   
fi

file5=`ls -l /etc/services | awk '{print $1}'`
if [ $file5 == "-rw-r--r--." ];then
  echo " [ √ ] /etc/services文件权限为644，符合要求"   
else
  echo " [ X ] /etc/services文件权限不为644，不符合要求，建议设置权限为644"   
fi

file6=`ls -l /etc/xinetd.conf | awk '{print $1}'`
if [ !-f $file6 ];then
  echo " [ √ ] /etc/xinetd.conf文件不存在,暂略此项"   
else
  if [ $file6 == "-rw-------." ];then
    echo " [ √ ] /etc/xinetd.conf文件权限为600，符合要求"   
  else
    echo " [ X ] /etc/xinetd.conf文件权限不为600，不符合要求，建议设置权限为600"   
  fi
fi

file7=`ls -l /etc/grub.conf | awk '{print $1}'`
if [ $file7 == "-rw-------." ];then
  echo " [ √ ] /etc/grub.conf文件权限为600，符合要求"   
else
  echo " [ X ] /etc/grub.conf文件权限为$file7，不符合要求，建议设置权限为600"   
fi

file8=`ls -l /etc/lilo.conf | awk '{print $1}'`
if [ -f /etc/lilo.conf ];then
  if [ $file8 == "-rw-------" ];then
    echo " [ √ ] /etc/lilo.conf文件权限为600，符合要求"   
  else
    echo " [ X ] /etc/lilo.conf文件权限不为600，不符合要求，建议设置权限为600"   
  fi
else
  echo " [ √ ] /etc/lilo.conf文件不存在,暂略此项"   
fi


Bssh=`cat /etc/ssh/sshd_config | grep  ^Banner`
if [ $Bssh == 0 ];then
    echo "ssh banner符合"   
else 
    echo "不符合"   
fi

echo "----------------------------"       
echo "检查密码长度及复杂度策略"   
if [ -e /etc/pam.d/system-auth ];then
    passComplexity=`cat /etc/pam.d/system-auth | grep "pam_tally.so.so"`
    passucredit=`cat /etc/pam.d/system-auth | grep "pam_tally.so.so" | grep -e ucredit | awk '{print $4}'`
    passlcredit=`cat /etc/pam.d/system-auth | grep "pam_tally.so.so" | grep -e lcredit | awk '{print $5}'`
    passdcredit=`cat /etc/pam.d/system-auth | grep "pam_tally.so.so" | grep -e dcredit | awk '{print $6}'`
    passocredit=`cat /etc/pam.d/system-auth | grep "pam_tally.so.so" | grep -e ocredit | awk '{print $7}'`
    echo "密码复杂度策略为：${passComplexity}"       
    echo "密码复杂度策略中设置的大写字母个数为：${passucredit}"   
    echo "密码复杂度策略中设置的小写字母个数为：${passlcredit}"   
    echo "密码复杂度策略中设置的数字个数为：${passdcredit}"   
    echo "密码复杂度策略中设置的特殊字符个数为：${passocredit}"   
else
    ehco "不存在/etc/pam.d/system-auth文件"   
fi

echo "----------------------------" 
echo "检查是否存在未授权的suid/sgid文件" 
for PART in `grep -v ^# /etc/fstab | awk '($6 != "0") {print "/./"$2 }'`; do
    RESULT=`find $PART -type f -xdev \( -perm -04000 -o -perm -02000 \) -print`
        if [ -n $RESULT ];then
            flag=1
        else
            flag=0
        fi
done
if [ $flag -eq 0 ];then
    echo "返回值为空，符合规范" 
else [ $flag -eq 1 ]
    echo "返回值不为空，不符合规范" 
fi
