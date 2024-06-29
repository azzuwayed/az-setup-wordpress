#!/bin/bash

# Accept WordPress path and repo path as parameters
wp_path=$1
repo_path=$2
plugins_dir="${repo_path}/az-plugins"

# Ensure the az-plugins directory exists
if [ ! -d "$plugins_dir" ]; then
    echo "The az-plugins directory was not found in the repository path."
    echo -e "\n"
    exit 1
fi

# Function to copy and activate plugin in the WordPress plugins directory
copy_and_activate_plugin() {
    local plugin_dir=$1
    local wp_plugins_dir="${wp_path}/wp-content/plugins"
        
    # Extract plugin name from directory path
    local plugin_name=$(basename "$plugin_dir")

    echo "Do you want to install and activate the plugin: $plugin_name? (y/n)"
    read -r install_choice
    
    if [ "$install_choice" = "y" ]; then
        # Copy the plugin directory to the WordPress plugins directory
        cp -r "$plugin_dir" "$wp_plugins_dir"
        echo "Installed: $plugin_name"
        echo -e "\n"
        
        # Activate the plugin using WP-CLI
        wp plugin activate "$plugin_name" --path="$wp_path"
        echo "Activated: $plugin_name"
        echo -e "\n"
    else
        echo "Skipped: $plugin_name"
        echo -e "\n"
    fi
}

# Iterate over each directory in the az-plugins folder and ask the user before copying and activating
for plugin_dir in "$plugins_dir"/*; do
    if [ -d "$plugin_dir" ]; then
        copy_and_activate_plugin "$plugin_dir"
    fi
done

echo "Exiting wp-plugins.sh script..."
echo -e "\n"
