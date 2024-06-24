#!/bin/bash
# wp-init.sh

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

echo_warning
confirm_proceed

# Delete default plugins
wp plugin delete akismet hello || { echo "Failed to delete default plugins"; exit 1; }

# Install and activate "Hello Elementor" theme
wp theme install hello-elementor --activate || { echo "Failed to install and activate Hello Elementor"; exit 1; }
wp theme list --field=name | grep -v 'hello-elementor' | xargs -I {} wp theme delete {}

# Delete 'Hello World!' post
wp post delete 1 --force || { echo "Failed to delete 'Hello World!' post"; exit 1; }

# Delete 'Sample Page'
wp post delete 2 --force || { echo "Failed to delete 'Sample Page'"; exit 1; }

# Create and set 'Home' page as the front page
home_page_id=$(wp post create --post_type=page --post_title='Home' --post_status=publish --porcelain)
wp option update show_on_front 'page' || { echo "Failed to update show_on_front option"; exit 1; }
wp option update page_on_front "$home_page_id" || { echo "Failed to update page_on_front option"; exit 1; }

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
    wp option update "$option" "${options[$option]}" || { echo "Failed to update option $option"; exit 1; }
done

# Update Permalink Settings
wp rewrite structure '/%postname%/' --hard || { echo "Failed to update permalink structure"; exit 1; }
wp rewrite flush --hard || { echo "Failed to flush rewrite rules"; exit 1; }

echo "Exiting wp-init.sh script..."
echo ""