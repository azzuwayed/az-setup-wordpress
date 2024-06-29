
## Introduction

This collection of scripts is designed for developers and system administrators who frequently deploy WordPress websites across various servers and environments. It streamlines the initial setup process, making it quicker and easier to get a WordPress site up and running.

> **Warning:** This project is still a work-in-progress. Always back up your data before executing these scripts. Use at your own risk!

<br>

## Installation

Clone the repository to a safe location, such as the home directory:

`git clone https://github.com/azzuwayed/az-setup-wordpress.git` 

<br>

## Run the Script

Navigate to the cloned directory and execute the main setup script, which will copy the following included scripts to the entered WordPress installation path, run and remove them. This design flow to maintain the ownership of changes.

`cd az-setup-wordpress && chmod +x ./wp-setup.sh && sudo ./wp-setup.sh` 

### Included Scripts

==== `/wp-init.sh` ====

This script automates several WordPress setup tasks, including:

-   Checking and installing WP-CLI if not already installed.
-   Cleanup default plugins, themes, and posts.
-   Creating a custom home page and setting it as the front page.
-   Updating WordPress settings like timezone, date format, and permalink structure.
-   Switch from http to https

==== `/wp-config.sh` ====

This script will prompt you to enable, disable, or skip various WordPress configuration settings, including:

-   Debugging and Error Handling
-   Performance Optimization
-   Content Management Optimization
-   Automatic Updates and Maintenance

Each option can be enabled (1), disabled (0), or skipped by pressing Enter. The script creates a backup of your current `wp-config.php` before making changes, allowing you to revert if necessary.

==== `./wp-plugins.sh` ====

This script will iterate over each directory in the az-plugins folder and ask the user before copying the accepted plugins, then activates them.