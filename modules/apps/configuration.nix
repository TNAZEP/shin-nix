{
  config,
  pkgs,
  antigravity-pkg,
  ...
}:

let
  antigravityPkgs = import antigravity-pkg {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "tnazep" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    htop
    fastfetch
    firefox
    antigravityPkgs.antigravity
  ];
}
