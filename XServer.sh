#!/bin/bash
KonfigApache(){
    sleep 4
    clear
    echo " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-";
    echo " Pilih File yang akan dikonfigurasi                              ";
    echo " [1] apache2.conf                                                ";
    echo " [2] ports.conf                                                  ";
    echo " [3] security.conf                                               ";
    echo " [4] 000-default.conf                                            ";
    echo " [5] ssl-default.conf                                            ";
    echo " [6] Buat Site Baru                                              ";
    echo " [7] Edit Konfigurasi Site                                       ";
    echo " [8] Konfigurasi HTTPS Apache2                                   ";
    echo " [9] Cek Konfigurasi apache2                                     ";
    echo " [10] Restart apache2                                            ";
    echo " [11] Kembali ke Menu                                            ";
    echo "=================================================================";
    read -p " Masukkan Nomor Pilihan Anda antara [1 - 11] : " prepo;
    echo "";
    case $prepo in
    1)  nano /etc/apache2/apache2.conf
    ;;
    2)  nano /etc/apache2/ports.conf
    ;;
    3)  nano /etc/apache2/conf-enabled/security.conf
    ;;
    4)  nano /etc/apache2/sites-available/000-default.conf
    ;;
    5)  nano /etc/apache2/sites-available/default-ssl.conf
    ;;
    6)  read -p "Masukkan nama site :" site
        nano /etc/apache2/sites-available/$site.conf
        a2ensite $site
    ;;
    7)  read -p "Masukkan nama site :" site1
        nano /etc/apache2/sites-available/$site1.conf
    ;;
    8)  read -p "Masukkan nama site :" site2
        a2enmod ssl headers rewrite socache_shmcb
        service apache2 restart
        cat << EOF >> /etc/apache2/sites-available/$site2.conf
# this configuration requires mod_ssl, mod_socache_shmcb, mod_rewrite, and mod_headers
<VirtualHost *:80>
RewriteEngine On
RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R=301,L]
</VirtualHost>

<VirtualHost *:443>
SSLEngine on
SSLCertificateFile      /path/to/signed_certificate
SSLCertificateChainFile /path/to/intermediate_certificate
SSLCertificateKeyFile   /path/to/private_key

# HTTP Strict Transport Security (mod_headers is required) (63072000 seconds)
Header set Strict-Transport-Security "max-age=63072000"
</VirtualHost>

# intermediate configuration, tweak to your needs
# SSLProtocol             all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
# SSLCipherSuite          ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
# SSLHonorCipherOrder     off
EOF
        nano /etc/apache2/sites-available/$site2.conf
    ;;
    9)  apache2ctl configtest
    ;;
    10) service apache2 restart
        systemctl status apache2
    ;;
    11) sleep 3
        startover
    ;;
    *)    echo "Maaf, menu tidak ada"
    esac
}
KonfigPHP(){
    sleep 4
    read -p "Masukkan Versi PHP : " vphp
    clear
    echo " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-";
    echo " Pilih File php.ini yang akan dikonfigurasi                       ";
    echo " [1]   Apache2                                                    ";
    echo " [2]   Command Line Interface                                     ";
    echo " [3]   FPM                                                        ";
    echo " [4]   Mods-available                                             ";
    echo " [5]   Kembali ke Menu Utama                                      ";
    echo "=================================================================";
    read -p " Masukkan Nomor Pilihan Anda antara [1 - 4] : " prepo;
    echo "";
    case $prepo in
    1)  if [ -z "$(ls -A /etc/php/${vphp}/apache2/php.ini)" ]; then
            echo "Tidak terdeteksi php.ini untuk apache2"
        else
            nano /etc/php/${vphp}/apache2/php.ini
            service apache2 restart
        fi
        ;;
    2)  if [ -z "$(ls -A /etc/php/${vphp}/cli/php.ini)" ]; then
            echo "Tidak terdeteksi php.ini untuk CLI"
        else
            nano /etc/php/${vphp}/cli/php.ini
            service apache2 restart
        fi
        ;;
    3)  if [ -z "$(ls -A /etc/php/${vphp}/fpm/php.ini)" ]; then
            echo "Tidak terdeteksi php.ini untuk fpm"
        else
            nano /etc/php/${vphp}/fpm/php.ini
            service apache2 restart
        fi
        ;;
    4)  if [ -z "$(ls -A /etc/php/${vphp}/mods-available/php.ini)" ]; then
            echo "Tidak terdeteksi php.ini untuk mods-available"
        else
            nano /etc/php/${vphp}/mods-available/php.ini
            service apache2 restart
        fi
        ;;
    5)  sleep 3
        startover
        ;;
    *)    echo "Maaf, menu tidak ada"
    esac

}
LogServer(){
    sleep 4
    clear
    echo " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-";
    echo " Pilih File yang akan dikonfigurasi                              ";
    echo " [1]   Cek file access.log.*                                      ";
    echo " [2]   Lihat log pengunjung website (real time)                   ";
    echo " [3]   Lihat semua log pengunjung website                         ";
    echo " [4]   Lihat sylog (real time)                                    ";
    echo " [5]   Lihat semua sylog                                          ";
    echo " [6]   Lihat messages (real time)                                 ";
    echo " [7]   Lihat semua messages                                       ";
    echo " [8]   Lihat auth.log (real time)                                 ";
    echo " [9]   Lihat semua auth.log                                       ";
    echo " [10]  Lihat kern.log (real time)                                 ";
    echo " [11]  Lihat semua kern.log                                       ";
    echo " [12]  Lihat wtmp log                                             ";
    echo " [13]  Lihat btmp log                                             ";
    echo " [14]  Kembali ke Menu Utama                                      ";
    echo "=================================================================";
    read -p " Masukkan Nomor Pilihan Anda antara [1 - 4] : " prepo;
    echo "";
    case $prepo in
    1)  if [ -z "$(ls -A /var/log/apache2/access.log*)" ]; then
            echo "Tidak terdeteksi access.log untuk apache2"
        else
            ls -l /var/log/apache2/access.log*
        fi
        ;;
    2)  if [ -z "$(ls -A /var/log/apache2/access.log)" ]; then
            echo "Tidak terdeteksi access.log untuk apache2"
        else
            tail -f /var/log/apache2/access.log
        fi
        ;;
    3)  if [ -z "$(ls -A /var/log/apache2/access.log)" ]; then
            echo "Tidak terdeteksi access.log untuk apache2"
        else
            cat /var/log/apache2/access.log | less
        fi
        ;;
    4)  if [ -z "$(ls -A /var/log/syslog)" ]; then
            echo "Tidak terdeteksi syslog"
        else
            tail -f /var/log/syslog
        fi
        ;;
    5)  if [ -z "$(ls -A /var/log/syslog)" ]; then
            echo "Tidak terdeteksi syslog"
        else
            cat /var/log/syslog | less
        fi
        ;;
    6)  if [ -z "$(ls -A /var/log/messages)" ]; then
            echo "Tidak terdeteksi messages"
        else
            tail -f /var/log/messages
        fi
        ;;
    7)  if [ -z "$(ls -A /var/log/messages)" ]; then
            echo "Tidak terdeteksi messages"
        else
            cat /var/log/messages | less
        fi
        ;;
    8)  if [ -z "$(ls -A /var/log/auth.log)" ]; then
            echo "Tidak terdeteksi auth.log"
        else
            tail -f /var/log/auth.log
        fi
        ;;
    9)  if [ -z "$(ls -A /var/log/auth.log)" ]; then
            echo "Tidak terdeteksi auth.log"
        else
            cat /var/log/auth.log | less
        fi
        ;;
    10) if [ -z "$(ls -A /var/log/kern.log)" ]; then
            echo "Tidak terdeteksi kern.log"
        else
            tail -f /var/log/kern.log
        fi
        ;;
    11) if [ -z "$(ls -A /var/log/kern.log)" ]; then
            echo "Tidak terdeteksi kern.log"
        else
            cat /var/log/kern.log | less
        fi
        ;;
    12) if [ -z "$(ls -A /var/log/wtmp)" ]; then
            echo "Tidak terdeteksi wtmp"
        else
            last -f /var/log/wtmp
        fi
        ;;
    13) if [ -z "$(ls -A /var/log/btmp)" ]; then
            echo "Tidak terdeteksi btmp"
        else
            last -f /var/log/btmp
        fi
        ;;      
    14) sleep 3
        startover
    ;;
    *)    echo "Maaf, menu tidak ada"
    esac
}
again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]];
do
clear
echo "=================================================================";
echo " XServer Debian 11                                ";
echo " Progammer : Andreas Abi P.                       ";
echo "                                     ";
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=";
echo " Installasi server & konfigurasi                                 ";
echo " [1]  Installasi tools yang dibutuhkan                                  ";
echo " [2]  Setting IP Address                                         ";
echo " [3]  Setting Repository Indonesia                               ";
echo " [4]  Install Apache2, Mysql-server                              ";
echo " [5]  Install PHP                                                ";
echo " [6]  Install PHPMyadmin                                         ";
echo " [7]  Setting user dan direktori Web                             ";
echo " [8]  Install Codeigniter                                        ";
echo " [9]  Install Codeigniter 4                                            ";
echo " [10]  Install Wordpress                                         ";
echo " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-";
echo " Edit Konfigurasi                                                ";
echo " [11]  Edit konfigurasi apache2                                  ";
echo " [12]  Edit konfigurasi php.ini                                  ";
echo " [13]  Edit konfigurasi my.cnf                                   ";
echo " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-";
echo " Log Server                                                      ";
echo " [14]  Lihat Log Server                                          ";
echo " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-";
echo " [15]  Membuat Swap                                              ";
echo " [16]  Mengganti Hostname                                        ";
echo " [17]  Reboot                                                    ";
echo " [18]  Exit                                                      ";
echo "=================================================================";
read -p " Masukkan Nomor Pilihan Anda antara [1 - 18] : " choice;
echo "";
case $choice in
1)  if [ -z "$(ls -A /etc/default/grub)" ]; then
        echo "Grub tidak terdeteksi"
    else
        echo "Mengubah nama interface menjadi eth"
        sed -i 's,GRUB_CMDLINE_LINUX="",GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0",' /etc/default/grub
        update-grub
        apt update
        apt -y install arp-scan net-tools curl wget
        nano /etc/network/interfaces
        read -p "Enter untuk reboot"
        sleep 3
        reboot
    fi
    ;;
2)  if [ -z "$(ls -l /etc/network/interfaces)" ]; then
    echo "Tidak terdeteksi ada /etc/network/interfaces"
    else
    nano /etc/network/interfaces
    read -p "Apakah anda mau restart jaringan sekarang? y/n :" -n 1 -r
    echo 
        if [[ ! $REPLY =~ ^[Nn]$ ]]
        then
        for i in $(ls /sys/class/net/) ; do
            /usr/sbin/ip addr flush $i &
        done
        systemctl restart networking.service
        ifconfig
        fi
    fi
    ;;
3)  if [ -z "$(ls -l /etc/apt/sources.list)" ]; then
        echo "Tidak terdeteksi ada /etc/apt/sources.list"
    else
        cp /etc/apt/sources.list /etc/apt/sources.list.bak
        sleep 2
        clear
        echo " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-";
        echo " Daftar Server Repository                                        ";
        echo " [1] Kebo Pens                                                  ";
        echo " [2] Klas Surabaya                                                   ";
        echo " [3] Data Utama Surabaya                                         ";
        echo " [4] Ubaya                                               ";
        echo " [5] Repositori Resmi Debian 11                                  ";
        echo " [6] Kembali ke Menu Utama                                       ";
        echo "=================================================================";
        read -p " Masukkan Nomor Pilihan Anda antara [1 - 5] : " prepo;
        echo "";
        case $prepo in
        1) cat <<EOF > /etc/apt/sources.list
deb http://kebo.pens.ac.id/debian bullseye main contrib non-free
deb http://kebo.pens.ac.id/debian bullseye-updates main contrib non-free
deb http://kebo.pens.ac.id/debian-security bullseye-security main contrib non-free
EOF
        ;;
        2) cat <<EOF > /etc/apt/sources.list
deb https://buaya.klas.or.id/debian bullseye main contrib non-free
deb https://buaya.klas.or.id/debian bullseye-updates main contrib non-free
deb https://buaya.klas.or.id/debian-security bullseye-security main contrib non-free 
EOF
        ;;
        3) cat <<EOF > /etc/apt/sources.list
deb http://kartolo.sby.datautama.net.id/debian bullseye main contrib non-free
deb http://kartolo.sby.datautama.net.id/debian bullseye-updates main contrib non-free
deb http://kartolo.sby.datautama.net.id/debian-security bullseye-security main contrib non-free   
EOF
        ;;
        4) cat <<EOF > /etc/apt/sources.list
deb https://suro.ubaya.ac.id/debian bullseye main contrib non-free
deb https://suro.ubaya.ac.id/debian bullseye-updates main contrib non-free
deb https://suro.ubaya.ac.id/debian-security bullseye-security main contrib non-free 
EOF
        ;;
        5) cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian bullseye main contrib non-free
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb http://deb.debian.org/debian bullseye-backports main contrib non-free
deb http://security.debian.org/debian-security/ bullseye-security main contrib non-free
EOF
        ;;
        6)  sleep 2
            startover
        ;;
        *)    echo "Maaf, menu tidak ada"
        esac
        read -p "Apakah anda mau melakukan apt update sekarang? y/n :" -n 1 -r
        echo 
            if [[ ! $REPLY =~ ^[Nn]$ ]]
            then
                apt update
            fi
        fi
    ;;
4)  read -p "Apakah anda mau yakin mau install apache2 dan MySQL? y/n :" -n 1 -r
    echo  ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then
        apt -y install apache2
        echo "Apache2 sudah diinstall"
        echo "Menginstall MariaDB Server"
        apt -y install gnupg
        wait $!
        apt update
        apt -y install mariadb-server
        wait $!
        mysql_secure_installation
        wait $!
        service mysql restart
        read -p "Apakah anda mau membuat user baru untuk mysql :" -n 1 -r
        echo  ""
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            # jika ya
            read -p "Masukkan password root MYSQL : " rootpasswd
            read -p "Masukkan username baru database MYSQL :" user_db
            read -p "Masukkan password untuk $user_db :" pass_db
            mysql -uroot -p$rootpasswd -e "CREATE USER '$user_db'@'%' IDENTIFIED BY '$pass_db';" > /dev/null 2>&1
            mysql -uroot -p$rootpasswd -e "GRANT ALL PRIVILEGES ON *.* TO '$user_db'@'%';" > /dev/null 2>&1
            mysql -uroot -p$rootpasswd -e "FLUSH PRIVILEGES;" > /dev/null 2>&1   
        fi
    fi
    ;;
5)  read -p "Apakah anda mau yakin mau install PHP? y/n :" -n 1 -r
    echo  ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then
        read -p "Apakah anda mau mau install PHP bawaan Debian 11? ( PHP 7.4 ) y/n :" -n 1 -r
        echo  ""
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            apt -y install php wget php-cli php-zip php-common php-fpm php-cgi php-xml php-gd php-mysqli php-mbstring libapache2-mod-php php-common php-mysql php-curl php-intl 
            echo "Berhasil menginstall PHP 7.4"
        else
            apt-get -y install apt-transport-https lsb-release ca-certificates curl
            curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg 
            sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
            apt update
            read -p 'Berapa jumlah versi php yang akan diinstall ?: ' choose;
            echo "-------------------------------------------------------------------------------"
            for i in `seq 1 $choose`;
            do
            read -p "Masukan Versi PHP ke $i: " vphp;
                echo "Install php$vphp"
                apt install -y php$vphp wget php$vphp-cli php$vphp-zip php$vphp-common php$vphp-fpm php$vphp-cgi php$vphp-xml php$vphp-gd php$vphp-mysqli php$vphp-mbstring libapache2-mod-php$vphp php$vphp-common php$vphp-mysql php$vphp-curl php$vphp-intl
                apt install -y libapache2-mod-fcgid
                a2enmod actions fcgid alias proxy_fcgi
                echo "Install Module php$vphp"    
            done            
        fi
    fi
    ;;
6)  echo "Mendownload PHPMyadmin versi terbaru"
    apt install phpmyadmin -y
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
    echo "Cek Konfigurasi apache2"
    apache2ctl configtest
    echo "Restart apache2"
    service apache2 restart
    echo "PHPMyadmin berhasil diinstall"
    ;;
7)  read -p "Masukkan nama user: " user
    read -p "Masukkan nama group user: " group
    addgroup $group
    read -p "Masukkan password untuk user: " passwd
    read -p "Masukkan home directory untuk user: " home
    read -p "Masukkan direktory web : " homeweb
    mkdir $home
    mkdir $homeweb
    egrep "^$user" /etc/passwd >> /dev/null
    pass=$(perl -e 'print crypt($ARGV[0], "password")'  $passwd );
    useradd -d $home -g $group -p $pass $user
    let i=$i+1;
    [ $? -eq 0 ]; echo "User $user berhasil dibuat" || "gagal"
    echo "Mengatur permission pada folder home"
    chown -R $user:$group $home
    usermod -aG www-data $user
    echo "Mengatur apache2"
    cat <<EOF >> /etc/apache2/apache2.conf
<Directory $home>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF
    echo "Membuat Virtualhost apache2"
    cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot $homeweb
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
    echo "Cek Konfigurasi apache2"
    apache2ctl configtest
    echo "Restart apache2"
    service apache2 restart
    service apache2 status
    ;;
8)  read -p "Masukkan versi CodeIgniter (Versi 3) :" versiCI
    read -p "Masukkan user web : " userweb
    read -p "Masukkan direktory web : " dirweb
    read -p "Masukkan nama database untuk Codeigniter :" nama_db
    read -p "Masukkan hostname database :" host_db
    read -p "Masukkan password root MYSQL : " rootpasswd
    echo ""
    read -p "Apakah anda mau membuat user baru untuk mysql :" -n 1 -r
    echo  ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        # jika ya
        
        read -p "Masukkan username baru database MYSQL :" user_db
        read -p "Masukkan password untuk $user_db :" pass_db
        mysql -uroot -p$rootpasswd -e "CREATE USER '$user_db'@'%' IDENTIFIED BY '$pass_db';" > /dev/null 2>&1
        mysql -uroot -p$rootpasswd -e "GRANT ALL PRIVILEGES ON *.* TO '$user_db'@'%';" > /dev/null 2>&1
        mysql -uroot -p$rootpasswd -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
        
    else
        read -p "Masukkan username database MYSQL :" user_db
        read -p "Masukkan password database MYSQL :" pass_db     
    fi
    echo "Membuat database untuk CodeIginiter"
    mysql -uroot -p$rootpasswd -e "CREATE DATABASE $nama_db /*\!40100 DEFAULT CHARACTER SET utf8 */;" > /dev/null 2>&1
    echo "Download Codeigniter"
    cd /tmp
    wget https://github.com/bcit-ci/CodeIgniter/archive/${versiCI}.tar.gz
    echo "Instalasi Codeingiter"
    tar xvf ${versiCI}.tar.gz > /dev/null 2>&1
    mv CodeIgniter-${versiCI}/* $dirweb
    chown -R ${userweb}:www-data $dirweb
    cd ~/
    echo "Konfigurasi .htaccess"
    a2enmod headers rewrite > /dev/null 2>&1
    touch $dirweb/.htaccess
    cat <<EOF >> $dirweb/.htaccess
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php/$1 [L]
EOF
    chown -R ${userweb}:www-data $dirweb
    echo "Konfigurasi CodeIgniter"
    sed -i "s|\$config\['index_page'\] = 'index.php'|\$config\['index_page'\] = ''|" $dirweb/application/config/config.php
    sed -i "s|\$config\['base_url'\] = '';|#\$config\['base_url'\] = '';|" $dirweb/application/config/config.php
    cat << EOF >> $dirweb/application/config/config.php
\$base_url = ((isset(\$_SERVER['HTTPS']) && \$_SERVER['HTTPS'] == "on") ? "https" : "http");
\$base_url .= "://". @\$_SERVER['HTTP_HOST'];
\$base_url .= str_replace(basename(\$_SERVER['SCRIPT_NAME']),"",\$_SERVER['SCRIPT_NAME']);
\$config['base_url'] = \$base_url;
EOF
    sed -i "s|'hostname' => 'localhost'|'hostname' => '${host_db}'|" $dirweb/application/config/database.php
    sed -i "s|'username' => ''|'username' => '${user_db}'|" $dirweb/application/config/database.php
    sed -i "s|'password' => ''|'password' => '${pass_db}'|" $dirweb/application/config/database.php
    sed -i "s|'database' => ''|'database' => '${nama_db}'|" $dirweb/application/config/database.php
    echo "Konfigurasi CodeIgniter Telah selesai"
    echo "Cek Konfigurasi apache2"
    apache2ctl configtest
    echo "Restart apache2"
    service apache2 restart    
    ;;  
9)  read -p "Masukkan user web : " userweb
    read -p "Masukkan direktory user : " diruser
    read -p "Masukkan direktory web : " dirweb
    read -p "Masukkan nama aplikasi :" nama_app
    read -p "Masukkan URL Web :" url_web
    read -p "Masukkan hostname database :" host_db
    read -p "Masukkan nama database untuk Codeigniter 4 :" nama_db
    read -p "Masukkan password root MYSQL : " rootpasswd
    echo ""
    read -p "Apakah anda mau membuat user baru untuk mysql y/n:" -n 1 -r
    echo  ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        # jika ya
        
        read -p "Masukkan username baru database MYSQL :" user_db
        read -p "Masukkan password untuk $user_db :" pass_db
        mysql -uroot -p$rootpasswd -e "CREATE USER '$user_db'@'%' IDENTIFIED BY '$pass_db';" > /dev/null 2>&1
        mysql -uroot -p$rootpasswd -e "GRANT ALL PRIVILEGES ON *.* TO '$user_db'@'%';" > /dev/null 2>&1
        mysql -uroot -p$rootpasswd -e "FLUSH PRIVILEGES;" > /dev/null 2>&1 
        
    else
        read -p "Masukkan username database MYSQL :" user_db
        read -p "Masukkan password database MYSQL :" pass_db     
    fi
    echo "Membuat database untuk Laravel"
    mysql -uroot -p$rootpasswd -e "CREATE DATABASE $nama_db /*\!40100 DEFAULT CHARACTER SET utf8 */;" > /dev/null 2>&1
    echo "Menghentikan Service Apache2 dan Mysql"
    service apache2 stop
    wait $!
    service mysql stop
    wait $!
    echo "Service berhasil dihentikan"
    echo "Service berhasil dihentikan"
    echo "Install Paket yang dibutuhkan"
    apt -y install curl git unzip
    echo "Menginstall Composer"
    apt install -y composer
    wait $!
    su -c "composer create-project -d ${diruser} codeigniter4/appstarter ${diruser}/${nama_app}" $userweb
    cd $diruser/$nama_app
    echo "Mengkonfigurasi CodeIgniter 4"
    cp env .env
    sed -i "s|# database.default.hostname = localhost|database.default.hostname = ${host_db}|" .env
    sed -i "s|# database.default.database = ci4|database.default.database = ${nama_db}|" .env
    sed -i "s|# database.default.username = root|database.default.username = ${user_db}|" .env
    sed -i "s|# database.default.password = root|database.default.password = ${pass_db}|" .env
    sed -i "s|public \$baseURL = 'http://localhost:8080/';|public \$baseURL = '${url_web}';|" app/Config/App.php
    su -c "ln -s $diruser/$nama_app/public $dirweb" abipermana
    chown -R $userweb:www-data $diruser/$nama_app
    chmod -R 775 $diruser/$nama_app
    sleep 1
    service apache2 start
    wait $!
    service mysql start
    wait $!
    echo "CodeIgniter 4 Berhasil Diinstall :)"
    ;;
10) read -p "Masukkan user web : " userweb
    read -p "Masukkan direktory web : " dirweb
    read -p "Masukkan nama database untuk Wordpress :" nama_db
    read -p "Masukkan hostname database :" host_db
    read -p "Masukkan password root MYSQL : " rootpasswd
    echo ""
    read -p "Apakah anda mau membuat user baru untuk mysql :" -n 1 -r
    echo  ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        # jika ya
        read -p "Masukkan username baru database MYSQL :" user_db
        read -p "Masukkan password untuk $user_db :" pass_db
        mysql -uroot -p$rootpasswd -e "CREATE USER '$user_db'@'%' IDENTIFIED BY '$pass_db';" > /dev/null 2>&1
        mysql -uroot -p$rootpasswd -e "GRANT ALL PRIVILEGES ON *.* TO '$user_db'@'%';" > /dev/null 2>&1
        mysql -uroot -p$rootpasswd -e "FLUSH PRIVILEGES;" > /dev/null 2>&1
        
    else
        read -p "Masukkan username database MYSQL :" user_db
        read -p "Masukkan password database MYSQL :" pass_db     
    fi
    echo "Membuat database untuk Wordpress" 
    mysql -uroot -p$rootpasswd -e "CREATE DATABASE $nama_db /*\!40100 DEFAULT CHARACTER SET utf8 */;" > /dev/null 2>&1
    echo "Download Wordpress"
    cd /tmp
    ip=$(curl ifconfig.me)
    wget https://wordpress.org/latest.tar.gz
    echo "Instalasi Wordpress"
    tar xvf latest.tar.gz > /dev/null 2>&1
    mv wordpress/* $dirweb
    echo "Konfigurasi Wordpress"
    cp $dirweb/wp-config-sample.php $dirweb/wp-config.php
    chown -R ${userweb}:www-data $dirweb
    chmod -R 775 $dirweb
    echo "Konfigurasi wp-config.php"
    sed -i "s|database_name_here|${nama_db}|" $dirweb/wp-config.php
    sed -i "s|username_here|${user_db}|" $dirweb/wp-config.php
    sed -i "s|password_here|${pass_db}|" $dirweb/wp-config.php
    sed -i "s|localhost|${host_db}|" $dirweb/wp-config.php
    echo "Cek Konfigurasi apache2"
    apache2ctl configtest
    echo "Restart apache2"
    service apache2 restart
    echo "Konfigurasi Wordpress Telah selesai"
    echo "silahkan buka http://${ip}/wp-admin/install.php untuk konfigurasi selanjutnya"
    ;;
11) KonfigApache
    ;;

12) KonfigPHP
    ;;

13) if [ -z "$(ls -A /etc/mysql/mysql.conf.d/mysqld.cnf)" ]; then
        echo "Tidak terdeteksi mysqld.cnf"
    else
        nano /etc/mysql/mysql.conf.d/mysqld.cnf
    fi
    ;;

14) LogServer
    ;;

15) read -p "Masukkan jumlah swap yang ingin ditambahkan (MB):" swap
    /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=$swap
    chmod 600 /var/swap.1
    /sbin/mkswap /var/swap.1
    /sbin/swapon /var/swap.1   
    ;;
16) read -p "Masukkan nama hostname baru :" hostname
    hostnamectl set-hostaname $hostname
    logout
    ;;

17) read -p "Apakah anda yakin akan restart? y/n :" -n 1 -r
    echo 
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then
    reboot
    fi
    ;;

18) exit
    ;;
*)    echo "Maaf, menu tidak ada"
esac

echo -n "Kembali ke menu? [y/n]: ";
read again;
while [[ $again != 'Y' ]] && [[ $again != 'y' ]] && [[ $again != 'N' ]] && [[ $again != 'n' ]];
do
echo "Masukkan yang anda pilih tidak ada di menu";
echo -n "Kembali ke menu? [y/n]: ";
read again;
done
done
