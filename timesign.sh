#!/bin/bash
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
#    echo $THEFILE
    FILESHA1=$(openssl sha1 $THEFILE | egrep '\w+$' -o)
#    echo $FILESHA1
    FILEDATE=$(date +%Y%m%d)
#    echo $FILEDATE
    FILESAVENAME=${FILESHA1:0:15}_${FILEDATE}_$THEFILE
#    echo $FILESAVENAME
    cp $THEFILE ./backup/$FILESAVENAME

#进行签名
    openssl ts -query -data "./backup/$FILESAVENAME" -cert -sha256 \
	| curl -s -H "$CONTENT_TYPE" -H "$ACCEPT_TYPE" --data-binary @- $TIMESTAMPSERVER  \
	-o ./timestamp/$FILESAVENAME.tsr
#输出签名信息
    openssl ts -reply -in ./timestamp/$FILESAVENAME.tsr -text

#验证签名
    openssl ts -verify -data "$THEFILE" -in ./timestamp/$FILESAVENAME.tsr -CAfile "$CAFILE"

done
