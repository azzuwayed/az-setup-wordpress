
# Introduction

This collection of scripts is designed for developers and system administrators who frequently deploy WordPress websites across various servers and environments. It streamlines the initial setup process, making it quicker and easier to get a WordPress site up and running.

> **Warning:** This project is still a work-in-progress. Always back up your data before executing these scripts. Use at your own risk.

# Installation

Clone the repository to a safe location, such as the home directory:

`git clone https://github.com/azzuwayed/az-setup-wordpress.git` 

## Run the Script

Navigate to the cloned directory and execute the setup script:

`cd az-setup-wordpress
sudo ./wp-setup.sh` 

### Customizing WordPress Configuration

`/wp-init.sh` 

The scripts automate several WordPress setup tasks, including:

-   Checking and installing WP-CLI if not already installed.
-   Deleting default plugins and themes, and installing preferred ones.
-   Creating a custom home page and setting it as the front page.
-   Updating WordPress settings like timezone, date format, and permalink structure.

---

`/wp-config.sh` 

This script will prompt you to enable, disable, or skip various WordPress configuration settings, including:

-   Debugging and Error Handling
-   Performance Optimization
-   Content Management Optimization
-   Automatic Updates and Maintenance

Each option can be enabled (1), disabled (0), or skipped by pressing Enter. The script creates a backup of your current `wp-config.php` before making changes, allowing you to revert if necessary.