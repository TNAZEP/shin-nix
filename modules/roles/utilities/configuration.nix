{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zed-editor
    vscodium
    gh
  ];
}
