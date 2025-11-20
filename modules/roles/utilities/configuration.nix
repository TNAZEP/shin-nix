{
  config,
  pkgs,
  antigravity-pkg,
  userSettings,
  ...
}:
let
  antigravityPkgs = import antigravity-pkg {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = with pkgs; [
    antigravityPkgs.antigravity
    nixfmt-rfc-style
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ userSettings.username ];
  };

}
