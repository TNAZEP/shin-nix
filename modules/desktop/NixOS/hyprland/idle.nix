{ config, ... }:
let
  colors = config.meta.theme.colors;
  userSettings = config.meta.settings;
in
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
            {
              timeout = 480;
              on-timeout = "brightnessctl -s set 10";
              on-resume = "brightnessctl -r";
            }
            {
              timeout = 600;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 630;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
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
              outer_color = "rgb(${builtins.substring 1 6 colors.border})";
              inner_color = "rgb(${builtins.substring 1 6 colors.bg})";
              font_color = "rgb(${builtins.substring 1 6 colors.fg-muted})";
              fade_on_empty = false;
              fade_timeout = 1000;
              placeholder_text = "<i>Password...</i>";
              hide_input = false;
              rounding = 0;
              check_color = "rgb(${builtins.substring 1 6 colors.accent-alt})";
              fail_color = "rgb(${builtins.substring 1 6 colors.error})";
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              fail_timeout = 2000;
              fail_transition = 300;
              capslock_color = "rgb(${builtins.substring 1 6 colors.warning})";
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
            {
              monitor = "";
              text = "$TIME";
              text_align = "center";
              color = "rgb(${builtins.substring 1 6 colors.fg-muted})";
              font_size = 90;
              font_family = userSettings.font;
              position = "0, 150";
              halign = "center";
              valign = "center";
            }
            {
              monitor = "";
              text = "cmd[update:60000] date '+%A, %d %B'";
              text_align = "center";
              color = "rgb(${builtins.substring 1 6 colors.fg-dim})";
              font_size = 24;
              font_family = userSettings.font;
              position = "0, 60";
              halign = "center";
              valign = "center";
            }
            {
              monitor = "";
              text = "Hi, $USER";
              text_align = "center";
              color = "rgb(${builtins.substring 1 6 colors.fg-dim})";
              font_size = 18;
              font_family = userSettings.font;
              position = "0, -90";
              halign = "center";
              valign = "center";
            }
          ];
        };
      };

      home.packages = [ pkgs.brightnessctl ];
    };
}
