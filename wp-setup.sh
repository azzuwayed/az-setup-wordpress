#!/bin/bash

# This file must be placed above the public folder of WordPress

# If you are root user, use this command to run the script within WordPress folder
# cp ../wp-setup.sh . && sudo chown www:www wp-setup.sh && sudo chmod 755 wp-setup.sh && sudo -u www ./wp-setup.sh

# Check if WP-CLI is installed
if ! command -v wp &> /dev/null
then
    echo "WP-CLI could not be found. Please install WP-CLI to use this script."
    exit 1
fi

# Delete specified plugins
wp plugin delete akismet
wp plugin delete hello

# Install and activate "Hello Elementor" theme
wp theme install hello-elementor --activate

# Delete all themes except "Hello Elementor"
for theme in $(wp theme list --field=name); do
    if [ "$theme" != "hello-elementor" ]; then
        wp theme delete "$theme"
    fi
done

# Delete 'Hello World!' post
wp post delete 1 --force

# Delete 'Sample Page'
wp post delete 2 --force

# Create a new page titled 'Home'
home_page_id=$(wp post create --post_type=page --post_title='Home' --post_status=publish --porcelain)

# Set the 'Home' page as the front page
wp option update show_on_front 'page'
wp option update page_on_front "$home_page_id"

# Update General Settings
wp option update timezone_string "Asia/Riyadh"
wp option update date_format "d/m/Y"
wp option update time_format "g:i A"
wp option update start_of_week 0  # 0 is Sunday

# Update Discussion Settings
wp option update default_pingback_flag 0
wp option update default_ping_status 0

# Update Media Settings
wp option update uploads_use_yearmonth_folders 0

# Update Permalink Settings
wp rewrite structure '/%postname%/' --hard
wp rewrite flush --hard

# Remove this script
rm -- "$0"

echo "Setup complete"
