{ config, ... }:
let
  userSettings = config.meta.settings;
in
{
  flake.nixosModules.ai =
    { pkgs, ... }:
    {
      # Ollama - Local LLM server with AMD GPU acceleration
      services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm; 
        openFirewall = true;
        host = "0.0.0.0";
        port = 11434;
        # environmentVariables = {
        #   HSA_OVERRIDE_GFX_VERSION = "11.0.0";  # RX 7900 series
        # };
      };

      services.open-webui = {
        enable = true;
        port = 3000;
        host = "0.0.0.0";
        openFirewall = true;
        environment = {
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
          WEBUI_AUTH = "False";
        };
      };

      hardware.graphics.extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];

      users.users.${userSettings.username}.extraGroups = [ "render" "video" ];

      environment.systemPackages = with pkgs; [
        ollama-rocm
        oterm
      ];
    };
}
