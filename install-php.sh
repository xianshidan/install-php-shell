#!/bin/bash

#安装php

lsdir=$(pwd)

phpnamegz='php-5.5.7.tar.gz'
phpname='php-5.5.7'
phpprefix="/usr/local/php-5.5.7"

libxml2namegz="libxml2-2.6.31.tar.gz"
libxml2name="libxml2-2.6.31"
libxml2prefix="/usr/local/libxml2"

curlnamegz="curl-7.34.0.tar.gz"
curlname="curl-7.34.0"
curlprefix="/usr/local/curl"

zlibnamegz="zlib-1.2.8.tar.gz"
zlibname="zlib-1.2.8"

libpngnamegz="libpng-1.4.2.tar.gz"
libpngname="libpng-1.4.2"
libpngprefix="/usr/local/libpng"

freetypenamegz="freetype-2.2.1.tar.gz"
freetypename="freetype-2.2.1"
freetypeprefix="/usr/local/freetype"

jpegnamegz="jpegsrc.v8.tar.gz"
jpegname="jpeg-8"
jpegprefix="/usr/local/jpeg"

memcachenamegz="memcache-3.0.8.tgz"
memcachename="memcache-3.0.8"

redisnamezip="phpredis-master.zip"
redisname="phpredis-master"

phpizebin="${phpprefix}/bin/phpize"
phpconfig="${phpprefix}/bin/php-config"

etcnamegz="etc.tar.gz"

info_log="${lsdir}/install.log"
err_log="${lsdir}/err.log"

if [ -f ${info_log} ];
then
    rm ${info_log}
fi

if [ -f ${err_log} ];
then
    rm ${err_log}
fi

pkill php

echo '-----------uninstall php-----------'|tee -a ${info_log} ${err_log} 

php_rpm=`rpm -qa|grep -i php`
if [ "${php_rpm}" ];
then
    subindex=`expr index ${php_rpm} " "`
fi

if [ -z "${php_rpm}" ];
then
    echo '-----------php not installed-----------'|tee -a ${info_log} ${err_log}
elif [ "${subindex}" -le 0 ];
then
    echo "-----------need install: ${php_rpm}-----------"|tee -a ${info_log}
    rpm -e --nodeps ${php_rpm} 1>>${info_log} 2>>${err_log} 
    echo '-----------uninstall php complete-----------'|tee -a ${info_log}
else
    php_rpm_array=(${php_rpm})

    for a in ${php_rpm_array[@]}
    do
        echo "need install: ${a}" |tee -a ${info_log}
        rpm -e --nodeps ${a} 1>>${info_log} 2>>${err_log}
    done
    echo "-----------uninstall php complete-----------"|tee -a ${info_log} ${err_log}
fi


echo "-----------compile install libxml2-----------"|tee -a ${info_log} ${err_log}

if [ -d ${libxmlname} ];
then
    rm -rf ${libxmlname}
fi

tar -zxf ${libxml2namegz} 1>>${info_log} 2>>${err_log}
cd ${libxml2name}
./configure 1>>${info_log} 2>>${err_log}
make -j4 1>>${info_log} 2>>${err_log}
make install 1>>${info_log} 2>>${err_log}
cp xml2-config /usr/bin/
cd ..
echo "-----------install libxml2 complete-----------"|tee -a ${info_log} ${err_log}

echo "-----------compile install curl-----------"|tee -a ${info_log} ${err_log}

rm -rf ${curlname}
tar -zxf ${curlnamegz} 1>>${info_log} 2>>${err_log}
cd ${curlname}
./configure --prefix=${curlprefix} 1>>${info_log} 2>>${err_log}
make -j4 1>>${info_log} 2>>${err_log}
make install 1>>${info_log} 2>>${err_log}
cd ..
echo "-----------install curl complete-----------"|tee -a ${info_log} ${err_log}

echo "-----------compile install zlib-----------"|tee -a ${info_log} ${err_log}

rm -rf ${zlibname}
tar -zxf ${zlibnamegz} 1>>${info_log} 2>>${err_log}
cd ${lsdir}/${zlibname}
./configure 1>>${info_log} 2>>${err_log}
make -j4 1>>${info_log} 2>>${err_log}
make install 1>>${info_log} 2>>${err_log}
cd ..
echo "-----------install zlib complete-----------"|tee -a ${info_log} ${err_log}


echo "-----------compile install libpng-----------"|tee -a ${info_log} ${err_log}

rm -rf ${libpngname}
tar -zxf ${libpngnamegz} 1>>${info_log} 2>>${err_log}
cd ${lsdir}/${libpngname}
./configure --prefix=${libpngprefix} 1>>${info_log} 2>>${err_log}
make -j4 1>>${info_log} 2>>${err_log}
make install 1>>${info_log} 2>>${err_log}
cd ..
echo "-----------install libpng complete-----------"|tee -a ${info_log} ${err_log}


echo "-----------compile install freetype-----------"|tee -a ${info_log} ${err_log}

rm -rf ${lsdir}/${freetypename}
tar -zxf ${lsdir}/${freetypenamegz} -C ${lsdir} 1>>${info_log} 2>>${err_log}
cd ${lsdir}/${freetypename}
./configure --prefix=${freetypeprefix} 1>>${info_log} 2>>${err_log}
make -j4 1>>${info_log} 2>>${err_log}
make install 1>>${info_log} 2>>${err_log}
cd ..
echo "-----------install freetype complete-----------"|tee -a ${info_log} ${err_log}


echo "-----------compile install jpeg-----------"|tee -a ${info_log} ${err_log}

rm -rf ${lsdir}/${jpegname}
tar -zxf ${lsdir}/${jpegnamegz} 1>>${info_log} 2>>${err_log}
cd ${lsdir}/${jpegname}
./configure --prefix=${jpegprefix} 1>>${info_log} 2>>${err_log}
make -j4 1>>${info_log} 2>>${err_log}
make install 1>>${info_log} 2>>${err_log}
cd ..
echo "-----------install jpeg complete-----------"|tee -a ${info_log} ${err_log}


echo "-----------start install php-----------"|tee -a ${info_log} ${err_log}

rm -rf ${lsdir}/${phpname}
tar -zxf ${lsdir}/${phpnamegz} -C ${lsdir} 1>>${info_log} 2>>${err_log}
cd ${lsdir}/${phpname}

./configure --prefix=${phpprefix} --with-config-file-path=${phpprefix}/etc --with-gd --with-freetype-dir=${freetypeprefix} --with-jpeg-dir=${jpegprefix} --with-png-dir=${libpngprefix} --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-iconv --with-curl=${curlprefix} --disable-ipv6 --enable-mbstring --enable-gd-native-ttf --enable-static --enable-sockets --enable-xml --enable-fpm --enable-opcache 1>>${info_log} 2>>${err_log}
make -j4 1>>${info_log} 2>>${err_log}
make install 1>>${info_log} 2>>${err_log}
cd ..

echo '-----------install php complete-----------'|tee -a ${info_log} ${err_log}

echo '-----------install php memcache-----------'|tee -a ${info_log} ${err_log}

rm -rf ${lsdir}/${memcachename}
tar -zxf ${lsdir}/${memcachenamegz} -C ${lsdir} 1>>${info_log} 2>>${err_log}
cd ${lsdir}/${memcachename}
${phpizebin} 1>>${info_log} 2>>${err_log}
./configure --with-php-config=${phpconfig} 1>>${info_log} 2>>${err_log}
make -j4 1>>${info_log} 2>>${err_log}
make install 1>>${info_log} 2>>${err_log}
cd ..

echo '-----------memcache install complete-----------'|tee -a ${info_log} ${err_log}


echo '-----------install php redis-----------'|tee -a ${info_log} ${err_log}

rm -rf ${lsdir}/${redisname}
unzip ${lsdir}/${redisnamezip} 1>>${info_log} 2>>${err_log}
cd ${lsdir}/${redisname}
${phpizebin} 1>>${info_log} 2>>${err_log}
./configure --with-php-config=${phpconfig} 1>>${info_log} 2>>${err_log}
make -j4 1>>${info_log} 2>>${err_log}
make install 1>>${info_log} 2>>${err_log}
cd ..

echo '-----------redis install complete-----------'|tee -a ${info_log} ${err_log}

echo '-----------config php-----------'|tee -a ${info_log} ${err_log}

mv ${phpprefix}/etc ${phpprefix}/etc.bak 1>>${info_log} 2>>${err_log}
tar zxf ${lsdir}/${etcnamegz} -C ${phpprefix} 1>>${info_log} 2>>${err_log}

rm -rf /etc/init.d/fpm 1>>${info_log} 2>>${err_log}
cp ${lsdir}/${phpname}/sapi/fpm/init.d.php-fpm /etc/init.d/fpm 1>>${info_log} 2>>${err_log}
chmod +x /etc/init.d/fpm 1>>${info_log} 2>>${err_log}

mkdir -p /data/logs/fpm 1>>${info_log} 2>>${err_log}
touch /data/logs/fpm/php-fpm-error.log 1>>${info_log} 2>>${err_log}
touch /data/logs/fpm/vip.wps.cn.access.log 1>>${info_log} 2>>${err_log}
touch /data/logs/fpm/vip.wps.cn.log.slow 1>>${info_log} 2>>${err_log}

groupadd www 1>>${info_log} 2>>${err_log}
useradd -g www www 1>>${info_log} 2>>${err_log}


chown -Rv www:www /data/logs/fpm/php-fpm-error.log 1>>${info_log} 2>>${err_log}
chown -Rv www:www /data/logs/fpm/vip.wps.cn.access.log 1>>${info_log} 2>>${err_log}
chown -Rv www:www /data/logs/fpm/vip.wps.cn.log.slow 1>>${info_log} 2>>${err_log}

echo '-----------config php complete-----------'|tee -a ${info_log} ${err_log}


echo '-----------start php-----------'|tee -a ${info_log} ${err_log}

chown -Rv www:www ${phpprefix} 1>>${info_log} 2>>${err_log}
su -c "/etc/init.d/fpm start" www 1>>${info_log} 2>>${err_log}

