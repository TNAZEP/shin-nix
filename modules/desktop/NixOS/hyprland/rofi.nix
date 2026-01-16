{
  flake.homeModules.rofi =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.rofi
        (pkgs.writeShellScriptBin "power-menu" ''
          entries="Shut down\nSleep\nLogout"
          selected=$(echo -e "$entries" | ${pkgs.rofi}/bin/rofi -dmenu -i -p "Power" -theme theme)
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
          font: "JetBrainsMono Nerd Font 16";
          show-icons: false;
          terminal: "alacritty";
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

      xdg.configFile."rofi/theme.rasi".source = ./rofi-theme.rasi;
    };
}
