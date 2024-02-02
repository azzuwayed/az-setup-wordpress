#!/bin/bash

# Accept WordPress path and repo path as parameters
wp_path=$1
repo_path=$2
plugins_dir="${repo_path}/az-plugins"

# Ensure the az-plugins directory exists
if [ ! -d "$plugins_dir" ]; then
    echo "The az-plugins directory was not found in the repository path."
    echo ""
    exit 1
fi

# Ask for the WordPress installation directory
echo "Enter the path to your WordPress installation:"
echo ""
read -r wp_path

# Validate the WordPress installation directory
if [ ! -d "$wp_path/wp-content/plugins" ]; then
    echo "Invalid WordPress installation path."
    echo ""
    exit 1
fi

# Function to copy plugin to the WordPress plugins directory
copy_plugin() {
    local plugin_dir=$1
    local wp_plugins_dir="${wp_path}/wp-content/plugins"
        
    # Extract plugin name from directory path
    local plugin_name=$(basename "$plugin_dir")

    echo "Do you want to install the plugin: $plugin_name? (y/n)"
    read -r install_choice
    
    if [ "$install_choice" = "y" ]; then
        # Copy the plugin directory to the WordPress plugins directory
        cp -r "$plugin_dir" "$wp_plugins_dir"
        echo "Installed: $plugin_name"
        echo ""
    else
        echo "Skipped: $plugin_name"
        echo ""
    fi
}

# Iterate over each directory in the az-plugins folder and ask the user before copying
for plugin_dir in "$plugins_dir"/*; do
    if [ -d "$plugin_dir" ]; then
        copy_plugin "$plugin_dir"
    fi
done

echo "Exiting wp-plugins.sh script..."
echo ""