#!/bin/bash
#-------------CopyRight-------------
#    名称:文件可信时间戳工具
#    语言:bash shell
#    时间:2013-03-31
#    作者:Hugo Qin
#    邮箱:fireuponsky@gmail.com
#-------------许可证-------------
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------

#各种常量
CONTENT_TYPE="Content-Type: application/timestamp-query"
ACCEPT_TYPE="Accept: application/timestamp-reply"
TIMESTAMPSERVER="http://timestamp.comodoca.com/rfc3161"
CAFILE="cacert.pem"

#检查配置文件
if [[ ! -e ./files.list ]]
then
    echo "Can't find ./files.list"
    exit 1
elif [[ ! -r ./files.list ]]
then
    echo "Can't read ./files.list"
    exit 1
fi
#如果文件末尾无回车给配置文件末尾追加一个回车
if [ $(tail -1 files.list | grep -E "^$" | wc -l) -eq 0 ]
then
    echo -e "\n" >> ./files.list
fi
#检查所需目录
if [[ ! -d backup ]]
then
    mkdir backup
fi
if [[ ! -d timestamp ]]
then
    mkdir timestamp
fi

#备份要签名的文件
cat ./files.list | while read THEFILE
do
#判断是否为空行
if [ ! "$THEFILE" ]
then
    continue;
fi
#判断文件是否存在
if [ ! -e "$THEFILE" ]
then
    echo "Can't find $THEFILE!"
    continue;
fi

    FILESHA1=$(openssl sha1 $THEFILE | egrep '\w+$' -o)
    FILEDATE=$(date +%Y%m%d)
    FILESAVENAME=${FILESHA1:0:15}_${FILEDATE}_$THEFILE
    cp $THEFILE ./backup/$FILESAVENAME

#进行签名
    openssl ts -query -data "./backup/$FILESAVENAME" -cert -sha256 \
	| curl -s -H "$CONTENT_TYPE" -H "$ACCEPT_TYPE" --data-binary @- $TIMESTAMPSERVER  \
	-o ./timestamp/$FILESAVENAME.tsr
#输出签名信息
    echo "----------$THEFILE---BEGIN----------"
    echo "SHA1:$FILESHA1"
    echo "----------Timestamping Info----------"
    openssl ts -reply -in ./timestamp/$FILESAVENAME.tsr -text

#验证签名
    echo "----------Verification----------"
    openssl ts -verify -data "$THEFILE" -in ./timestamp/$FILESAVENAME.tsr -CAfile "$CAFILE"
    echo "----------$THEFILE---END----------"
done
exit 0
