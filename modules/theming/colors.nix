{ lib, config, ... }:
let
  themes = {
    kanagawa-dragon = {
      bg = "#181616";
      bg-alt = "#252525";
      fg = "#c5c9c5";
      fg-dim = "#a6a69c";
      fg-muted = "#c8c093";
      accent = "#c4746e";
      accent-alt = "#e46876";
      error = "#e82424";
      warning = "#e98a00";
      border = "#a6a69c";
      border-inactive = "#353535";
    };

    catppuccin-mocha = {
      bg = "#1e1e2e";
      bg-alt = "#313244";
      fg = "#cdd6f4";
      fg-dim = "#a6adc8";
      fg-muted = "#bac2de";
      accent = "#f38ba8";
      accent-alt = "#eba0ac";
      error = "#f38ba8";
      warning = "#fab387";
      border = "#6c7086";
      border-inactive = "#45475a";
    };

    tokyo-night = {
      bg = "#1a1b26";
      bg-alt = "#24283b";
      fg = "#c0caf5";
      fg-dim = "#a9b1d6";
      fg-muted = "#9aa5ce";
      accent = "#f7768e";
      accent-alt = "#ff9e64";
      error = "#f7768e";
      warning = "#e0af68";
      border = "#565f89";
      border-inactive = "#3b4261";
    };

    gruvbox-dark = {
      bg = "#282828";
      bg-alt = "#3c3836";
      fg = "#ebdbb2";
      fg-dim = "#d5c4a1";
      fg-muted = "#bdae93";
      accent = "#fb4934";
      accent-alt = "#fe8019";
      error = "#fb4934";
      warning = "#fabd2f";
      border = "#928374";
      border-inactive = "#504945";
    };
  };
in
{
  options.meta.theme = {
    colors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = themes.${config.meta.settings.theme} or themes.kanagawa-dragon;
      description = "Active theme color palette";
    };

    available = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = builtins.attrNames themes;
      readOnly = true;
      description = "List of available theme names";
    };
  };
}
