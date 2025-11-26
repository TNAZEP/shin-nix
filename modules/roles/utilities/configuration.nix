{
  config,
  pkgs,
  userSettings,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    antigravity
    nixfmt-rfc-style
    hyprshot
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ userSettings.username ];
  };

}
