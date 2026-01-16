{ config, ... }:
let
  userSettings = config.meta.settings;
  monitors = userSettings.monitors;
in
{
  flake.homeModules.waybar =
    { pkgs, ... }:
    let
      mainMonitor = monitors.main.output;
      secondMonitor = monitors.secondary.output;

      # Shared bar configuration
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
          format = "<span color='#252525'>[ </span>{text}<span color='#252525'> ]</span>";
          exec = "date +'%H:%M %a, %b %d' | awk '{print tolower($0)}'";
          interval = 3;
        };

        cpu = {
          format = "<span color='#252525'>[ </span><span color='#c4746e'>cpu: </span>{icon0}{icon1}{icon2}{icon3} {usage:>2}%<span color='#252525'> / </span>";
          format-icons = [
            " "
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
        };

        "hyprland/language" = {
          format = "<span color='#c4746e'>key: </span>{short}<span color='#252525'> / </span>";
          tooltip = false;
        };

        pulseaudio = {
          format = "<span color='#c4746e'>vol:</span> {volume}%";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        battery = {
          format = "<span color='#252525'> / </span><span color='#c4746e'>bat:</span> {capacity}%";
          format-charging = "<span color='#252525'> / </span><span color='#c4746e'>ac:</span> {capacity}%";
          tooltip = false;
          interval = 20;
        };

        backlight = {
          format = "<span color='#252525'> / </span><span color='#c4746e'>mon:</span> {percent}%<span color='#252525'> ]</span>";
          tooltip = false;
        };

        tray = {
          icon-size = 20;
          spacing = 7;
          tooltip = false;
        };

        "custom/power" = {
          format = "<span color='#252525'>[ </span><span color='#c4746e'>⏻ </span><span color='#252525'>]</span>";
          on-click = "power-menu";
          tooltip = false;
        };
      };
    in
    {
      programs.waybar = {
        enable = true;
        settings = {
          # Main monitor bar (DP-1)
          mainBar = sharedBarConfig // {
            output = mainMonitor;
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
                "${mainMonitor}" = [
                  1
                  2
                  3
                  4
                  5
                ];
              };
            };
          };

          # Second monitor bar
          secondBar = sharedBarConfig // {
            output = secondMonitor;
            "hyprland/workspaces" = {
              disable-scroll = true;
              all-outputs = false;
              # Use {name} to display the custom workspace names (1-10) instead of IDs (11-20)
              format = "{icon}{name}";
              format-icons = {
                default = " ";
                urgent = "!";
                active = "*";
              };
              persistent-workspaces = {
                "${secondMonitor}" = [
                  11
                  12
                  13
                  14
                  15
                ];
              };
            };
          };
        };
        style = ''
          @define-color accent #c4746e;
          @define-color fg #c5c9c5;
          @define-color bg #181616;
          @define-color bg-alt #a6a69c;

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
              font-family: "JetBrainsMono Nerd Font";
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
              font-family: "JetBrainsMono Nerd Font";
              color: @fg;
          }

          #workspaces {
              font-family: "JetBrainsMono Nerd Font";
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
