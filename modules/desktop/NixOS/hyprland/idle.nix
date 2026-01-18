{
  flake.homeModules.hypridle =
    { pkgs, ... }:
    {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            # Dim screen after 8 minutes (before lock)
            {
              timeout = 480;
              on-timeout = "brightnessctl -s set 10";
              on-resume = "brightnessctl -r";
            }
            # Lock screen after 10 minutes
            {
              timeout = 600;
              on-timeout = "loginctl lock-session";
            }
            # Turn off displays 30 seconds after locking
            {
              timeout = 630;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            # Suspend after 2 hours
            {
              timeout = 7200;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };

      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            hide_cursor = true;
            grace = 5;
            no_fade_in = false;
            no_fade_out = false;
          };

          background = [
            {
              monitor = "";
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
              noise = 0.02;
              contrast = 0.9;
              brightness = 0.6;
              vibrancy = 0.2;
            }
          ];

          input-field = [
            {
              monitor = "";
              size = "300, 50";
              outline_thickness = 2;
              dots_size = 0.25;
              dots_spacing = 0.25;
              dots_center = true;
              dots_rounding = -1;
              outer_color = "rgb(a6a69c)";
              inner_color = "rgb(181616)";
              font_color = "rgb(c8c093)";
              fade_on_empty = false;
              fade_timeout = 1000;
              placeholder_text = "<i>Password...</i>";
              hide_input = false;
              rounding = 0;
              check_color = "rgb(e46876)";
              fail_color = "rgb(e82424)";
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              fail_timeout = 2000;
              fail_transition = 300;
              capslock_color = "rgb(e98a00)";
              numlock_color = -1;
              bothlock_color = -1;
              invert_numlock = false;
              swap_font_color = false;
              position = "0, -20";
              halign = "center";
              valign = "center";
            }
          ];

          label = [
            # Time
            {
              monitor = "";
              text = "$TIME";
              text_align = "center";
              color = "rgb(c8c093)";
              font_size = 90;
              font_family = "JetBrains Mono Nerd Font";
              position = "0, 150";
              halign = "center";
              valign = "center";
            }
            # Date
            {
              monitor = "";
              text = "cmd[update:60000] date '+%A, %d %B'";
              text_align = "center";
              color = "rgb(a6a69c)";
              font_size = 24;
              font_family = "JetBrains Mono Nerd Font";
              position = "0, 60";
              halign = "center";
              valign = "center";
            }
            # Greeting
            {
              monitor = "";
              text = "Hi, $USER";
              text_align = "center";
              color = "rgb(afa193)";
              font_size = 18;
              font_family = "JetBrains Mono Nerd Font";
              position = "0, -90";
              halign = "center";
              valign = "center";
            }
          ];
        };
      };

      home.packages = [
        pkgs.brightnessctl
      ];
    };
}
