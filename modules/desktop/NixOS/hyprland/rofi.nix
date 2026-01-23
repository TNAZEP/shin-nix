{ config, ... }:
let
  colors = config.meta.theme.colors;
  userSettings = config.meta.settings;
in
{
  flake.homeModules.rofi =
    { pkgs, ... }:
    let
      rofiTheme = ''
        * {
            bg: ${colors.bg};
            bg-alt: ${colors.bg-alt};
            fg: ${colors.fg};
            accent: ${colors.accent};
            background-color: @bg;

            color: @fg;
            border: 0;
            border-color: @bg;
            margin: 0;
            padding: 0;
            spacing: 0;
            highlight: none;
        }

        window {
            width: 385px;
            border: 2px solid;
            border-color: @fg;
        }

        element {
            padding: 2px 4px 2px 4px;
            text-color: @fg;
        }

        element-text {
            vertical-align: 0.5;
            padding: 5px;
        }

        element-text selected {
            color: @accent;
        }

        entry {
            background-color: @bg;
            columns: 1;
            lines: 20;
        }

        inputbar {
            children: [prompt, entry];
            border: 0 0 1px 0;
            border-color: @bg-alt;
            margin: 10px 10px 0 10px;
            padding: 0 0 5px 0;
        }

        prompt {
            text-color: @accent;
            font: "${userSettings.font} Bold 16";
        }

        entry {
            border-color: @accent;
        }

        listview {
            background-color: @bg;
            columns: 1;
            lines: 5;
        }
      '';
    in
    {
      home.packages = [
        pkgs.rofi-wayland
        (pkgs.writeShellScriptBin "power-menu" ''
          entries="Shut down\nSleep\nLogout"
          selected=$(echo -e "$entries" | ${pkgs.rofi-wayland}/bin/rofi -dmenu -i -p "Power" -theme theme)
          if [ "$selected" = "Shut down" ]; then
            systemctl poweroff
          elif [ "$selected" = "Sleep" ]; then
            systemctl suspend
          elif [ "$selected" = "Logout" ]; then
            hyprctl dispatch exit
          fi
        '')
      ];

      xdg.configFile."rofi/config.rasi".text = ''
        configuration {
          modi: "drun";
          font: "${userSettings.font} 16";
          show-icons: false;
          terminal: "${userSettings.term}";
          icon-theme: "Papirus-Dark";
          drun-display-format: "{name}";
          display-drun: "search: ";
          timeout {
              action: "kb-cancel";
              delay:  0;
          }
          filebrowser {
              directories-first: true;
              sorting-method:    "name";
          }
        }
        @theme "theme"
      '';

      xdg.configFile."rofi/theme.rasi".text = rofiTheme;
    };
}
