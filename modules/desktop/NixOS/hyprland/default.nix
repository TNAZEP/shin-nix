{ inputs, config, ... }:
let
  userSettings = config.meta.settings;
in
{
  flake.nixosModules.hyprland =
    { ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    };

  flake.homeModules.hyprland =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.homeModules.waybar
        inputs.self.homeModules.rofi
        inputs.self.homeModules.dunst
      ];
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        plugins = [
          pkgs.hyprlandPlugins.hyprexpo
        ];
        settings = {
          # Environment Variables
          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            "QT_QPA_PLATFORMTHEME,kde"
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_QUICK_CONTROLS_STYLE,org.kde.desktop"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_AUTO_SCREEN_SCALE_FACTOR,1"
            "XDG_MENU_PREFIX,plasma-"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "GTK_USE_PORTAL,1"
          ];

          # Monitors
          monitor = [
            "DP-1,2560x1440@240,0x0,1,bitdepth,10"
          ];

          # General
          input = {
            kb_layout = "se";
            numlock_by_default = true;
            repeat_delay = 250;
            repeat_rate = 35;
            touchpad = {
              natural_scroll = true;
              disable_while_typing = true;
              clickfinger_behavior = true;
              scroll_factor = 0.5;
            };
            special_fallthrough = true;
            follow_mouse = 1;
          };

          binds = {
            scroll_event_delay = 0;
          };

          general = {
            gaps_in = 4;
            gaps_out = 8;
            gaps_workspaces = 50;
            border_size = 2;
            "col.active_border" = "rgb(a6a69c)";
            "col.inactive_border" = "rgb(353535)";
            resize_on_border = true;
            no_focus_fallback = true;
            layout = "dwindle";
            allow_tearing = true;
          };

          dwindle = {
            preserve_split = true;
            smart_split = false;
            smart_resizing = false;
          };

          decoration = {
            rounding = 0;
            blur = {
              enabled = true;
              xray = true;
              special = false;
              new_optimizations = true;
              size = 10;
              passes = 4;
              brightness = 1;
              noise = 0.01;
              contrast = 1;
              popups = true;
              popups_ignorealpha = 0.6;
            };
            shadow = {
              enabled = true;
              ignore_window = true;
              range = 20;
              offset = "0 2";
              render_power = 4;
              color = "rgba(0000002A)";
            };
            active_opacity = 0.9;
            inactive_opacity = 0.75;
            dim_inactive = false;
            dim_strength = 0.1;
            dim_special = 0;
          };

          animations = {
            enabled = true;
            bezier = [
              "linear, 0, 0, 1, 1"
              "md3_standard, 0.2, 0, 0, 1"
              "md3_decel, 0.05, 0.7, 0.1, 1"
              "md3_accel, 0.3, 0, 0.8, 0.15"
              "overshot, 0.05, 0.9, 0.1, 1.1"
              "crazyshot, 0.1, 1.5, 0.76, 0.92"
              "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
              "menu_decel, 0.1, 1, 0, 1"
              "menu_accel, 0.38, 0.04, 1, 0.07"
              "easeInOutCirc, 0.85, 0, 0.15, 1"
              "easeOutCirc, 0, 0.55, 0.45, 1"
              "easeOutExpo, 0.16, 1, 0.3, 1"
              "softAcDecel, 0.26, 0.26, 0.15, 1"
              "md2, 0.4, 0, 0.2, 1"
            ];
            animation = [
              "windows, 1, 3, md3_decel, popin 60%"
              "windowsIn, 1, 3, md3_decel, popin 60%"
              "windowsOut, 1, 3, md3_accel, popin 60%"
              "border, 1, 10, default"
              "fade, 1, 3, md3_decel"
              "layersIn, 1, 3, menu_decel, slide"
              "layersOut, 1, 1.6, menu_accel"
              "fadeLayersIn, 1, 2, menu_decel"
              "fadeLayersOut, 1, 0.5, menu_accel"
              "workspaces, 1, 7, menu_decel, slide"
              "specialWorkspace, 1, 3, md3_decel, slidevert"
            ];
          };

          misc = {
            vfr = 1;
            vrr = 2;
            animate_manual_resizes = false;
            animate_mouse_windowdragging = false;
            enable_swallow = false;
            swallow_regex = "(foot|kitty|alacritty|Alacritty)";
            disable_hyprland_logo = true;
            force_default_wallpaper = 0;
            new_window_takes_over_fullscreen = 2;
            allow_session_lock_restore = true;
            initial_workspace_tracking = false;
          };

          render = {
            cm_enabled = 1;
            cm_auto_hdr = 2;
            cm_fs_passthrough = 0;
          };

          plugin = {
            hyprexpo = {
              columns = 3;
              gap_size = 5;
              bg_col = "rgb(000000)";
              workspace_method = "first 1";
              enable_gesture = false;
              gesture_distance = 300;
              gesture_positive = false;
            };
          };

          experimental = {
            xx_color_management_v4 = true;
          };

          # Execs

          exec-once = [
            "swww-daemon"
            "waybar"
            "hypridle"
            "systemctl --user start plasma-polkit-agent"
            "kbuildsycoca6"
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP QT_QPA_PLATFORMTHEME QT_QPA_PLATFORM XDG_MENU_PREFIX"
            "swww img $HOME/Pictures/Wallpapers/skyline.jpg"
            "1password --silent"

            # Startup apps
            userSettings.browser
            "vesktop"
            "steam"
          ];

          # Window Rules
          windowrulev2 = [
            "float, class:org.pulseaudio.pavucontrol"
            "size 800 600, class:org.pulseaudio.pavucontrol"

            "workspace 1 silent, class:(firefox|Brave-browser)"
            "workspace 2 silent, class:(vesktop|org.telegram.desktop)"
            "workspace 5 silent, class:(steam)"
          ];

          # Keybinds
          "$mainMod" = "SUPER";
          "$terminal" = userSettings.term;
          "$fileManager" = "${userSettings.term} -e superfile";
          "$runmenu" = "rofi -show drun";
          "$browser" = userSettings.browser;
          "$editor" = userSettings.editor;
          "$script_dir" = "$HOME/.config/HyprCog";

          bind = [
            "$mainMod, Q, killactive,"
            "$mainMod, M, exit,"
            "$mainMod, W, togglefloating,"
            "$mainMod, SPACE, exec, $runmenu"
            "$mainMod SHIFT, SPACE, exec, $script_dir/power-menu"
            "$mainMod, P, pseudo,"
            "$mainMod, J, togglesplit,"
            "Super+Shift, F, fullscreen, 0"
            "Super+Shift, S, exec, hyprshot --mode region"
            "$mainMod SHIFT, c, exec, pkill waybar && hyprctl dispatch exec waybar"
            "$mainMod, RETURN, exec, $terminal"
            "$mainMod, E, exec, $fileManager"
            "$mainMod, F, exec, $browser"
            "$mainMod, C, exec, $editor"
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
          ];

          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          bindel = [
            ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
            ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
          ];

          bindl = [
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPrev, exec, playerctl previous"
          ];
        };
      };

      home.packages = [
        pkgs.swww
        pkgs.hyprshot
        pkgs.nwg-look
        pkgs.kdePackages.polkit-kde-agent-1
      ];

    };
}
