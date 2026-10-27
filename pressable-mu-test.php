<?php
/**
 * Plugin Name: Pressable MU Plugin Deployment Test
 * Description: Minimal test to verify that a custom MU-plugin is installed and loaded.
 * Version: 1.0.0
 */

defined('ABSPATH') || exit;

// Visible only to administrators with the manage_options capability.
// Does not expose secrets or alter site configuration.
add_action('admin_notices', function () {
    if (!current_user_can('manage_options')) {
        return;
    }

    echo '<div class="notice notice-success"><p>';
    echo esc_html('Pressable MU-plugin deployment test is loaded.');
    echo '</p></div>';
});
