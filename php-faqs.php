<?php

/**
 * I always forget what __DIR__ is. 
 * 
 * __DIR__ is a magic constant that returns the full directory path of the file where the __DIR__ constant is written. When you need 
 * to include or require another file in your script, using __DIR__ ensures that the path is correct regardless of where the script 
 * is called from. 
 * 
 */

echo __DIR__;


/**
 * *** Wordpress Plugin Header Comment options ***
 * Plugin Name: Name of the Plugin
 * Plugin URI: https://github.com/your-url.com
 * Description: A short description of the purpose of the plugin and what it does.
 * Version: Version number
 * Author: The Plugin Author
 * Author URI: https://github.com/your-url.com
 * License: The license of the plugin.
 * Requires PHP: The minimum required PHP version
 * Tested up to: The most recent version of Wordpress the the plugin has been tested on
 * Requires at least: The lowest WordPress version that the plugin will work on.
 * WC requires at least: 6.1
 * WC tested up to: 6.1
 */