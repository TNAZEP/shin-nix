{ inputs, config, ... }:
let
  userSettings = config.meta.settings;
  colors = config.meta.theme.colors;
  gtkSettings = config.meta.gtk;
  cursorSettings = config.meta.cursor;
  keyboardSettings = config.meta.keyboard;
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
    { pkgs, lib, hostConfig, ... }:
    let
      monitors = hostConfig.monitors;
      primaryMonitor = builtins.head (builtins.filter (m: m.primary) monitors ++ monitors);
      secondaryMonitors = builtins.filter (m: !m.primary && m.name != primaryMonitor.name) monitors;

      mkMonitorStr = m:
        let
          base = "${m.name},${toString m.width}x${toString m.height}@${toString m.refresh},${toString m.x}x${toString m.y},${toString m.scale}";
          bitdepth = if m.bitdepth != null then ",bitdepth,${toString m.bitdepth}" else "";
        in
        "${base}${bitdepth}";

      mkWorkspaces = monitor: startIdx: count:
        builtins.genList (i:
          let
            wsNum = startIdx + i;
            isDefault = i == 0;
            defaultStr = if isDefault then ", default:true" else "";
            nameStr = if startIdx > 1 then ", name:${toString (i + 1)}" else "";
          in
          "${toString wsNum}, monitor:${monitor.name}${defaultStr}${nameStr}"
        ) count;

      primaryWorkspaces = mkWorkspaces primaryMonitor 1 10;
      secondaryWorkspaces = builtins.concatLists (
        builtins.genList (i:
          let mon = builtins.elemAt secondaryMonitors i;
          in mkWorkspaces mon (11 + i * 10) 10
        ) (builtins.length secondaryMonitors)
      );
    in
    {
      imports = [
        inputs.self.homeModules.waybar
        inputs.self.homeModules.rofi
        inputs.self.homeModules.dunst
        inputs.self.homeModules.hypridle
        inputs.caelestia-shell.homeManagerModules.default
      ];

      # GTK theming
      gtk = {
        enable = true;
        theme = {
          name = "Yaru-purple-dark";
          package = pkgs.yaru-theme;
        };
        iconTheme = {
          name = "Yaru-purple-dark";
          package = pkgs.yaru-theme;
        };
        cursorTheme = {
          name = "Yaru";
          package = pkgs.yaru-theme;
          size = cursorSettings.size;
        };
        gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      };

      home.pointerCursor = {
        name = "Yaru";
        package = pkgs.yaru-theme;
        size = cursorSettings.size;
        gtk.enable = true;
        x11.enable = true;
      };

      # dconf settings for dark mode
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Yaru-purple-dark";
          icon-theme = "Yaru-purple-dark";
        };
      };

      # Systemd user service to ensure dconf is set at every login
      systemd.user.services.dconf-dark-mode = {
        Unit = {
          Description = "Set dark mode in dconf";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.writeShellScript "set-dark-mode" ''
            ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
            ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'Yaru-purple-dark'"
            ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/icon-theme "'Yaru-purple-dark'"
          ''}";
          RemainAfterExit = true;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      home.sessionVariables = {
        GTK_THEME = "Yaru-purple-dark";
        XCURSOR_THEME = "Yaru";
        XCURSOR_SIZE = toString cursorSettings.size;
        GSETTINGS_BACKEND = "dconf";
        # Force libadwaita to read from GSettings/dconf instead of portal
        ADW_DISABLE_PORTAL = "1";
      };

      wayland.windowManager.hyprland = {
        enable = true;
        plugins = [
          inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
        ];
        settings = {
          env = [
            "XCURSOR_SIZE,${toString cursorSettings.size}"
            "XCURSOR_THEME,Yaru"
            "HYPRCURSOR_SIZE,${toString cursorSettings.size}"
            "HYPRCURSOR_THEME,Yaru"
            "QT_QPA_PLATFORMTHEME,gnome"
            "QT_STYLE_OVERRIDE,adwaita-dark"
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_AUTO_SCREEN_SCALE_FACTOR,1"
            "XDG_CURRENT_DESKTOP,Hyprland:GNOME"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "GTK_THEME,Yaru-purple-dark"
            # Force libadwaita to read from GSettings/dconf instead of portal
            "ADW_DISABLE_PORTAL,1"
            "GSETTINGS_BACKEND,dconf"
          ];

          monitor = map mkMonitorStr monitors;
          workspace = primaryWorkspaces ++ secondaryWorkspaces;

          input = {
            kb_layout = keyboardSettings.layout;
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

          binds.scroll_event_delay = 0;

          general = {
            gaps_in = 4;
            gaps_out = 8;
            gaps_workspaces = 50;
            border_size = 2;
            "col.active_border" = "rgb(${builtins.substring 1 6 colors.border})";
            "col.inactive_border" = "rgb(${builtins.substring 1 6 colors.border-inactive})";
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
              enabled = false;
              xray = false;
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
            active_opacity = 1;
            inactive_opacity = 1;
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
            split-monitor-workspaces = {
              count = 10;
              keep_focused = 0;
              enable_notifications = 0;
              enable_persistent_workspaces = 0;
            };
          };

          experimental = { };

          "$mainMod" = "SUPER";
          "$terminal" = userSettings.term;
          "$fileManager" = "nautilus --new-window";
          "$runmenu" = "rofi -show drun";
          "$browser" = userSettings.browser;
          "$editor" = userSettings.editor;

          bind = [
            "$mainMod, Q, killactive,"
            "$mainMod, M, exit,"
            "$mainMod, L, exec, loginctl lock-session"
            "$mainMod, W, togglefloating,"
            "$mainMod, SPACE, exec, $runmenu"
            "$mainMod SHIFT, SPACE, exec, power-menu"
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
            "$mainMod, 1, split-workspace, 1"
            "$mainMod, 2, split-workspace, 2"
            "$mainMod, 3, split-workspace, 3"
            "$mainMod, 4, split-workspace, 4"
            "$mainMod, 5, split-workspace, 5"
            "$mainMod, 6, split-workspace, 6"
            "$mainMod, 7, split-workspace, 7"
            "$mainMod, 8, split-workspace, 8"
            "$mainMod, 9, split-workspace, 9"
            "$mainMod, 0, split-workspace, 10"
            "$mainMod SHIFT, 1, split-movetoworkspace, 1"
            "$mainMod SHIFT, 2, split-movetoworkspace, 2"
            "$mainMod SHIFT, 3, split-movetoworkspace, 3"
            "$mainMod SHIFT, 4, split-movetoworkspace, 4"
            "$mainMod SHIFT, 5, split-movetoworkspace, 5"
            "$mainMod SHIFT, 6, split-movetoworkspace, 6"
            "$mainMod SHIFT, 7, split-movetoworkspace, 7"
            "$mainMod SHIFT, 8, split-movetoworkspace, 8"
            "$mainMod SHIFT, 9, split-movetoworkspace, 9"
            "$mainMod SHIFT, 0, split-movetoworkspace, 10"
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

          windowrule = [
            "float on, match:class org.pulseaudio.pavucontrol"
            "size 800 600, match:class org.pulseaudio.pavucontrol"
            "workspace 1 silent, match:class (firefox|Brave-browser)"
            "workspace 2 silent, match:class (vesktop|org.telegram.desktop)"
            "workspace 5 silent, match:class (steam)"
          ];

          exec-once = [
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP"
            "systemctl --user import-environment"
            "swww-daemon"
            "waybar"
            "hypridle"
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
            "swww img $HOME/Pictures/Wallpapers/skyline.jpg"
            "1password --silent"
            userSettings.browser
            "vesktop"
            "steam"
          ];
        };
      };

      home.packages = with pkgs; [
        swww
        hyprshot
        nwg-look
        polkit_gnome
        playerctl
      ];
    };
}
