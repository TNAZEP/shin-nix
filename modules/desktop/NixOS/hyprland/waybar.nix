{ config, ... }:
let
  colors = config.meta.theme.colors;
  userSettings = config.meta.settings;
in
{
  flake.homeModules.waybar =
    { pkgs, hostConfig, ... }:
    let
      monitors = hostConfig.monitors;
      primaryMonitor = builtins.head (builtins.filter (m: m.primary) monitors ++ monitors);
      secondaryMonitors = builtins.filter (m: !m.primary && m.name != primaryMonitor.name) monitors;

      sharedBarConfig = {
        layer = "top";
        position = "top";
        exclusive = true;
        margin-top = 8;
        margin-left = 8;
        margin-right = 8;
        margin-bottom = 0;
        height = 30;
        spacing = 0;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/mode"
        ];
        modules-center = [ "custom/clock" ];
        modules-right = [
          "cpu"
          "hyprland/language"
          "pulseaudio"
          "battery"
          "backlight"
          "tray"
          "custom/power"
        ];

        "hyprland/mode" = {
          format = "  {}";
        };

        "custom/clock" = {
          format = "<span color='${colors.bg-alt}'>[ </span>{text}<span color='${colors.bg-alt}'> ]</span>";
          exec = "date +'%H:%M %a, %b %d' | awk '{print tolower($0)}'";
          interval = 3;
        };

        cpu = {
          format = "<span color='${colors.bg-alt}'>[ </span><span color='${colors.accent}'>cpu: </span>{icon0}{icon1}{icon2}{icon3} {usage:>2}%<span color='${colors.bg-alt}'> / </span>";
          format-icons = [ " " "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        };

        "hyprland/language" = {
          format = "<span color='${colors.accent}'>key: </span>{short}<span color='${colors.bg-alt}'> / </span>";
          tooltip = false;
        };

        pulseaudio = {
          format = "<span color='${colors.accent}'>vol:</span> {volume}%";
          on-click = "pavucontrol";
        };

        battery = {
          format = "<span color='${colors.bg-alt}'> / </span><span color='${colors.accent}'>bat:</span> {capacity}%";
          format-charging = "<span color='${colors.bg-alt}'> / </span><span color='${colors.accent}'>ac:</span> {capacity}%";
          tooltip = false;
          interval = 20;
        };

        backlight = {
          format = "<span color='${colors.bg-alt}'> / </span><span color='${colors.accent}'>mon:</span> {percent}%<span color='${colors.bg-alt}'> ]</span>";
          tooltip = false;
        };

        tray = {
          icon-size = 20;
          spacing = 7;
          tooltip = false;
        };

        "custom/power" = {
          format = "<span color='${colors.bg-alt}'>[ </span><span color='${colors.accent}'>⏻ </span><span color='${colors.bg-alt}'>]</span>";
          on-click = "power-menu";
          tooltip = false;
        };
      };

      mkBarConfig = monitor: workspaceIds: sharedBarConfig // {
        output = monitor.name;
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{icon}{name}";
          format-icons = {
            default = " ";
            urgent = "!";
            active = "*";
          };
          persistent-workspaces = {
            "${monitor.name}" = workspaceIds;
          };
        };
      };
    in
    {
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = mkBarConfig primaryMonitor [ 1 2 3 4 5 ];
        } // (builtins.listToAttrs (
          builtins.genList (i:
            let
              mon = builtins.elemAt secondaryMonitors i;
              startWs = 11 + i * 10;
            in {
              name = "bar${toString (i + 2)}";
              value = mkBarConfig mon (builtins.genList (j: startWs + j) 5);
            }
          ) (builtins.length secondaryMonitors)
        ));

        style = ''
          @define-color accent ${colors.accent};
          @define-color fg ${colors.fg};
          @define-color bg ${colors.bg};
          @define-color bg-alt ${colors.fg-dim};

          * {
              font-size: 16px;
              min-height: 0;
          }

          window#waybar {
              margin: 10px 10px 0px 10px;
              background-color: @bg;
              border-bottom: 2px solid @bg-alt;
              border-left: 2px solid @bg-alt;
              border-right: 2px solid @bg-alt;
              border-top: 2px solid @bg-alt;
          }

          #mode {
              font-family: "${userSettings.font}";
              font-weight: bold;
              color: @accent;
          }

          #language,
          #cpu,
          #pulseaudio,
          #battery,
          #backlight,
          #custom-clock,
          #custom-power {
              font-family: "${userSettings.font}";
              color: @fg;
          }

          #workspaces {
              font-family: "${userSettings.font}";
              border-bottom: 2px solid @bg-alt;
              border-left: 2px solid @bg-alt;
              border-top: 2px solid @bg-alt;
          }

          #workspaces button {
              padding: 7px 12px 7px 12px;
              color: @fg;
              background-color: @bg;
              border: none;
          }

          #workspaces button:hover {
              background: none;
              border: none;
              border-color: transparent;
              transition: none;
          }

          #workspaces button.active,
          #workspaces button.visible {
              border-radius: 0;
              color: @accent;
              font-weight: bold;
          }

          #tray {
              font-family: "Ubuntu";
              padding-right: 5px;
              padding-left: 10px;
          }
        '';
      };
    };
}
