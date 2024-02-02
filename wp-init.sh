#!/bin/bash

echo_warning() {
    echo "WARNING: This script will heavily modify your WordPress site."
    echo "It is strongly recommended that you take a full backup before proceeding."
}

confirm_proceed() {
    while true; do
        echo "Do you wish to continue? (y/n)"
        read -r proceed
        case $proceed in
            [Yy]* ) break;;
            [Nn]* ) echo "Script aborted. No changes made."; exit 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

check_wp_cli() {
    if ! command -v wp &> /dev/null; then
        echo "WP-CLI could not be found. Would you like to install it? (y/n)"
        read -r install_choice
        if [[ $install_choice == "y" || $install_choice == "Y" ]]; then
            if command -v curl &> /dev/null; then
                curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
                chmod +x wp-cli.phar
                sudo mv wp-cli.phar /usr/local/bin/wp
                if [ $? -ne 0 ]; then
                    echo "Failed to install wp-cli. Exiting."
                    exit 1
                fi
                echo "WP-CLI installed successfully."
            else
                echo "Curl is not installed. Please install curl to proceed."
                exit 1
            fi
        else
            echo "WP-CLI is required for this script to run."
            exit 1
        fi
    fi
}

echo_warning
confirm_proceed
check_wp_cli

# Delete default plugins
wp plugin delete akismet hello

# Install and activate "Hello Elementor" theme, delete other themes in a more efficient manner
wp theme install hello-elementor --activate
wp theme list --field=name | grep -v 'hello-elementor' | xargs -I {} wp theme delete {}

# Delete 'Hello World!' post
wp post delete 1 --force

# Delete 'Sample Page'
wp post delete 2 --force

# Create and set 'Home' page as the front page
home_page_id=$(wp post create --post_type=page --post_title='Home' --post_status=publish --porcelain)
wp option update show_on_front 'page'
wp option update page_on_front "$home_page_id"

# Update site options 
declare -A options=(
    ["timezone_string"]="Asia/Riyadh"
    ["date_format"]="d/m/Y"
    ["time_format"]="g:i A"
    ["start_of_week"]=0
    ["default_pingback_flag"]=0
    ["default_ping_status"]="closed"
    ["uploads_use_yearmonth_folders"]=0
)

for option in "${!options[@]}"; do
    wp option update "$option" "${options[$option]}"
done

# Update Permalink Settings
wp rewrite structure '/%postname%/' --hard
wp rewrite flush --hard

echo "WordPress site initialization completed successfully."