#!/bin/bash

DOT_FILE="$HOME/.wordpress-base"
WORDPRESS_REPO="git@github.com:WordPress/WordPress.git"
ETC_HOSTS="/etc/hosts"
MAMP="/applications/MAMP/conf/apache/extra/httpd-vhosts.conf"
LOCAL_IP="127.0.0.1"
R='\e[1;35m'
B='\e[0;36m'
G='\e[1;32m'
LBBG='\e[104m'
N=$(tput sgr0)

function banner() {
    printf "\n                                                                         \n"
    printf ${LBBG}
    printf "\n                                                                           "
    printf "\n  WordPress Configurator Script V 0.4.2                                      "
    printf "\n  ---------------------------------------------------------------------- \n"
    printf "  This script sets up a new WordPress project.                              "
    printf "\n  ---------------------------------------------------------------------- \n"
    printf "  Author: MotoRossi (hello@motorossi.me)                                   \n"
    printf "                                                                           \n"
    printf ${N}
}

function create_dot_file() {
    echo -n "What's the root directory for your projects? ${B}$HOME/${N}:\n"
    read SITE_ROOT
    if [ ! $SITE_ROOT ] || [ $SITE_ROOT == "" ]; then
        SITE_ROOT="~/Sites"
    fi
    echo "ROOT_DIR=${SITE_ROOT}" > $DOT_FILE
    printf "${B}Config file created.${N}\n"
}

function check_dot_file() {
    if [ ! -f "$DOT_FILE" ]; then
        printf "${R}Config file not found. Creating one now.${N}\n"
        create_dot_file
    fi
    source $DOT_FILE
}

function site_root_info() {
    printf "\n\n"
    printf "\n  ${G}Notice${N} "
    printf "\n  ----------------------------------------------------------------------  \n"
    printf "  This script was written with the assumption that MAMP is installed. \n"
    printf "  If not, go grab it at (${B}https://www.mamp.info/en/${N}\n"
    printf "  To get the full benefit, make sure you've configured MAMP to allow \n"
    printf "  symlinks and virtualhosts. If you haven't done that, you can follow \n"
    printf "  this quick tutorial: \n"
    printf "  ${B}https://github.com/CorradoRossi/resources/blob/master/wordpress-local-env.md${N} \n"
    printf "  It takes 10 minutes--trust me it's worth it!"
    printf "\n\n"
    printf "\n  ----------------------------------------------------------------------  \n"
    printf " \n Your site root is ${B}$ROOT_DIR${N}. To change it either\n"
    printf "  - update the ${B}$DOT_FILE${N} file or \n"
    printf "  - delete it, exit the script, and run it again.\n"
    printf "\n  ----------------------------------------------------------------------  \n"
    printf "                                                                          \n\n"

}

function site_local_domain() {
    printf "\n  ----------------------------------------------------------------------  \n"
    printf "  What do you want your dev domain name to be?\n"
    printf "  (Use .test as a TLD, for example:${B}mynewsite.test${N})\n"
    printf "  ${G}Set the development domain name:${N}"
    read DEV_DOMAIN

    if [ ! $SITE_DIRECTORY ] || [ $SITE_DIRECTORY == "" ]; then
        log "\n${R}Woops try again--make sure to use a valid TLD${N}"
        site_local_domain
        return
    fi
}

function set_vhost() {
    printf "\n  ----------------------------------------------------------------------  \n"
    printf "   \n"
    printf "   ${G}Setting virtualhost in .../apache/extra/httpd-vhosts.conf file.${N}" 
    printf "   \n"
    printf "\n  ----------------------------------------------------------------------  \n"
    printf "                                                                          \n\n"
    printf  "<VirtualHost *:80>\n   ServerName $DEV_DOMAIN\n    DocumentRoot \"$SITE_DIRECTORY\"\n</VirtualHost>\n" | sudo tee -a $MAMP > /dev/null
}

function set_etc_host() {
    printf "\n  ----------------------------------------------------------------------  \n"
    printf "   \n"
    printf "  ${G}Updating /etc/hosts with new virtualhost.${N}" 
    printf "   \n"
    printf "\n  ----------------------------------------------------------------------  \n"
    printf "                                                                          \n\n"
    printf "%s\t%s\n" "$LOCAL_IP" "$DEV_DOMAIN" | sudo tee -a $ETC_HOSTS > /dev/null
}

function get_and_create_site_directory() {
    printf "  ${G}Enter the directory for your new project. It will live here:${N}${B}$ROOT_DIR${N}/"
    read SITE_DIRECTORY

    if [ ! $SITE_DIRECTORY ] || [ $SITE_DIRECTORY == "" ]; then
        log "\n${R}Try again${N}"
        get_and_create_site_directory
        return
    fi

    SITE_DIRECTORY=$ROOT_DIR/$SITE_DIRECTORY

    if [ -d "$SITE_DIRECTORY" ]; then
        log "\n${R}$SITE_DIRECTORY directory already exists, hmm.${N}"
        get_and_create_site_directory
        return
    fi
    log "creating $SITE_DIRECTORY"
    mkdir $SITE_DIRECTORY
}

function clone_wordpress() {
	log "Cloning Wordpress into $SITE_DIRECTORY ..."
	cd $SITE_DIRECTORY
	git clone $WORDPRESS_REPO wordpress --depth=1
	rm -rf wordpress/.git
}

function cd_site_dir() {
	cd $SITE_DIRECTORY
}

function log() {
	printf "$1\n\n"
}

function create_config() {
    cp $SITE_DIRECTORY/wordpress/wp-config-sample.php $SITE_DIRECTORY/wordpress/wp-config.php 
}

function database_variables() {
    printf "   ${G}Enter your database name:${N}"
    read DATABASE_NAME

    if [ ! $DATABASE_NAME ] || [ $DATABASE_NAME == "" ]; then
        log "\n${R}Try again${N}"
        database_variables
        return
    fi

    printf "   ${G}Enter a new database username:${N}"
    read DATABASE_USERNAME

    if [ ! $DATABASE_USERNAME ] || [ $DATABASE_USERNAME == "" ]; then
        log "\n${R}Try again${N}"
        database_variables
        return
    fi

    printf "   ${G}Enter a new database password:${N}"
    read DATABASE_PASSWORD

    if [ ! $DATABASE_PASSWORD ] || [ $DATABASE_PASSWORD == "" ]; then
        log "\n${R}Try again${N}"
        database_variables
        return
    fi

    printf "   ${G}Change database prefix (optional but recommended ex. xyz_):${N}"
    read DATABASE_PREFIX

    if [ ! $DATABASE_PREFIX ] || [ $DATABASE_PREFIX == "" ]; then
        log "\n${R}Try again${N}"
        database_variables
        return
    fi
}

function find_replace() {
    log "${G}Replacing database variables in${N} ${B}wp-config.php${N}."
    find $SITE_DIRECTORY/wordpress/wp-config.php -type f | xargs sed -i '' "s/database_name_here/$DATABASE_NAME/g"
    find $SITE_DIRECTORY/wordpress/wp-config.php -type f | xargs sed -i '' "s/username_here/$DATABASE_USERNAME/g"
    find $SITE_DIRECTORY/wordpress/wp-config.php -type f | xargs sed -i '' "s/password_here/$DATABASE_PASSWORD/g"
    find $SITE_DIRECTORY/wordpress/wp-config.php -type f | xargs sed -i '' "s/'wp_'/'$DATABASE_PREFIX'/g"
}

function replace_salt() {
    log "${G}Replacing authentication unique keys and salt.${N}"
    SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
    STRING='put your unique phrase here'
    printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s $SITE_DIRECTORY/wordpress/wp-config.php
}

function completed_notice() {
    printf "\n  ${G}Done! Wasn't that easy?!${N}"
    printf "\n  ----------------------------------------------------------------------  \n"
    printf "  Next steps:\n"
    printf "  Open MAMP and create a new database with the database name you just entered. \n" 
    printf "  Restart MAMP and your site will be live at ${B}$DEV_DOMAIN${N}! \n"
    printf "  - have fun!"
    printf "\n  ----------------------------------------------------------------------  \n"
    printf "                                                                          \n\n"
}

banner
check_dot_file
site_root_info
get_and_create_site_directory
site_local_domain
clone_wordpress
create_config
database_variables
find_replace
replace_salt
set_vhost
set_etc_host
completed_notice