{
  flake.homeModules.dunst =
    { ... }:
    {
      services.dunst = {
        enable = true;
        settings = {
          global = {
            monitor = 0;
            follow = "none";
            width = 380;
            height = 200;
            origin = "top-right";
            offset = "10x10";
            scale = 0;
            notification_limit = 20;
            progress_bar = true;
            progress_bar_height = 9;
            progress_bar_frame_width = 1;
            progress_bar_min_width = 150;
            progress_bar_max_width = 400;
            progress_bar_corner_radius = 0;
            icon_corner_radius = 0;
            indicate_hidden = "yes";
            transparency = 0;
            separator_height = 3;
            padding = 8;
            horizontal_padding = 8;
            text_icon_padding = 0;
            frame_width = 2;
            frame_color = "#a6a69c";
            gap_size = 5;
            separator_color = "frame";
            sort = "yes";
            font = "JetBrains Mono Nerd Font 16";
            line_height = 0;
            markup = "full";
            format = "<b><span foreground='#afa193'>%s</span></b>\\n<span foreground='#f6f1ea'>%b</span>";
            alignment = "left";
            vertical_alignment = "center";
            show_age_threshold = 60;
            ellipsize = "middle";
            ignore_newline = "no";
            stack_duplicates = true;
            hide_duplicate_count = true;
            show_indicators = "no";
            enable_recursive_icon_lookup = true;
            icon_theme = "Papirus-Dark";
            icon_position = "left";
            min_icon_size = 32;
            max_icon_size = 64;
            icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";
            sticky_history = "yes";
            history_length = 20;
            browser = "/usr/bin/xdg-open";
            always_run_script = true;
            title = "Dunst";
            class = "Dunst";
            corner_radius = 0;
            ignore_dbusclose = false;
            force_xwayland = false;
            force_xinerama = false;
            mouse_left_click = "close_current";
            mouse_middle_click = "do_action, close_current";
            mouse_right_click = "close_all";
            highlight = "#e46876";
            background = "#181616";
            foreground = "#c8c093";
          };

          experimental = {
            per_monitor_dpi = false;
          };

          urgency_low = {
            timeout = 10;
          };

          urgency_normal = {
            timeout = 10;
          };

          urgency_critical = {
            timeout = 0;
          };
        };
      };
    };
}
