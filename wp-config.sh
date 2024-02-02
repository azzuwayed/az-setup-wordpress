#!/bin/bash

# Ensure wp-config.php exists
config_file="wp-config.php"
if [ ! -f "$config_file" ]; then
    echo "Error: wp-config.php not found. Please run this script from a WordPress installation directory."
    exit 1
fi

# Create a backup of wp-config.php with the current date and time
current_time=$(date +"%Y%m%d-%H%M%S")
backup_file="wp-config-backup-$current_time.php"
cp "$config_file" "$backup_file"
echo "Backup of wp-config.php created as $backup_file"

modify_config() {
    local setting="$1"
    local action="$2"
    local escaped_setting=$(echo "$setting" | sed 's/[\/&]/\\&/g')

    if [[ "$action" == "insert" ]]; then
        if ! grep -Fq "$setting" "$config_file"; then
            echo "$setting" >> "$config_file"
            echo "Inserted: $setting"
        fi
    elif [[ "$action" == "remove" ]]; then
        sed -i "/$(echo "$setting" | cut -d"'" -f2)/d" "$config_file"
        echo "Removed: $setting"
    fi
}

ask_group_preference() {
    local group_name="$1"
    echo "For $group_name settings, enter 0 to remove, 1 to enable, or press Enter to skip:"
    read -r choice
    case "$choice" in
        0) echo "remove";;
        1) echo "insert";;
        *) echo "skip";;
    esac
}

declare_changes() {
    local action="$1" settings=("${@:2}")
    [ "$action" == "skip" ] && return
    echo "Action '$action' will be applied to the following settings:"
    for setting in "${settings[@]}"; do
        echo "  - $setting"
    done
}

confirm_changes() {
    echo "Are you sure you want to apply the above changes? (y/n)"
    read -r confirmation
    if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
        echo "Changes not applied. Exiting."
        exit 1
    fi
}

settings_groups=(
    "Debugging and Error Handling"
    "Performance Optimization"
    "Content Management Optimization"
    "Automatic Updates and Maintenance"
)

declare -A settings=(
    ["Debugging and Error Handling"]=(
        "define('WP_DEBUG', true);"
        "define('WP_DEBUG_LOG', true);"
        "define('WP_DEBUG_DISPLAY', true);"
        "@ini_set('display_errors', 1);"
        "define('SCRIPT_DEBUG', true);"
        "define('SAVEQUERIES', true);"
        "define('CONCATENATE_SCRIPTS', false);" # false for better debugging
    )
    ["Performance Optimization"]=(
        "define('WP_MEMORY_LIMIT', '256M');"
        "define('WP_MAX_MEMORY_LIMIT', '512M');"
    )
    ["Content Management Optimization"]=(
        "define('AUTOSAVE_INTERVAL', 300);"
        "define('WP_POST_REVISIONS', 5);"
    )
    ["Automatic Updates and Maintenance"]=(
        "define('WP_AUTO_UPDATE_CORE', false);"
    )
)

# Main loop to process each settings group
for group in "${settings_groups[@]}"; do
    action=$(ask_group_preference "$group")
    declare_changes "$action" "${settings[$group]}"
done

confirm_changes

for group in "${settings_groups[@]}"; do
    action=$(ask_group_preference "$group")
    [ "$action" == "skip" ] && continue
    for setting in "${settings[$group]}"; do
        modify_config "$setting" "$action"
    done
done

echo "wp-config.php customization completed."
