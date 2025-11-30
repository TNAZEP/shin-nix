{
  flake.homeModules.rofi =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.rofi ];

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
