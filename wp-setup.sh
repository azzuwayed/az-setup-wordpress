#!/bin/bash

# Ask for the WordPress installation path
echo "Enter the path to your WordPress installation:"
echo ""
read -r wp_path

# Determine the path to the script's directory
repo_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Check if the path is valid and change directory
if [ -d "$wp_path" ]; then
    cd "$wp_path"
    echo "Changed directory to $wp_path"
    echo ""
    
    # Copy wp-init.sh and wp-config.sh from the repo to the WordPress directory
    cp "${repo_path}/wp-init.sh" ./wp-init.sh
    cp "${repo_path}/wp-config.sh" ./wp-config.sh
    cp "${repo_path}/wp-plugins.sh" ./wp-plugins.sh

    # Check the ownership of the WordPress directory
    wp_owner=$(stat -c '%U' .)
    wp_group=$(stat -c '%G' .)

    # Ensure the scripts have the same ownership
    sudo chown "$wp_owner:$wp_group" wp-init.sh wp-config.sh wp-plugins.sh

else
    echo "Invalid path. Please make sure the path is correct and try again."
    echo ""
    exit 1
fi

echo "Do you want to initialize a new WordPress website? (y/n)"
read -r init_choice

if [ "$init_choice" = "y" ]; then
    chmod +x ./wp-init.sh
    sudo -u "$wp_owner" ./wp-init.sh
    echo "WordPress initialization completed."
    echo ""
fi

echo "Do you want to update wp-config settings? (y/n)"
read -r config_choice

if [ "$config_choice" = "y" ]; then
    chmod +x ./wp-config.sh
    sudo -u "$wp_owner" ./wp-config.sh
    echo "wp-config settings updated."
    echo ""
fi

echo "Do you want to install default plugins? (y/n)"
read -r plugin_choice

if [ "$plugin_choice" = "y" ]; then
    chmod +x ./wp-plugins.sh
    sudo -u "$wp_owner" ./wp-plugins.sh "$wp_path" "$repo_path"
    echo "Default plugins installation completed."
    echo ""
fi

echo "Cleaning up setup scripts..."
rm -f ./wp-init.sh ./wp-config.sh ./wp-plugins.sh
echo "Setup scripts removed from WordPress directory."
echo ""

echo "Setup complete."
echo ""