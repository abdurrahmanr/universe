{
  inputs,
  ...
}:
{
  imports = [
    inputs.helium-flake.nixosModules.default
  ];

  programs.helium = {
    enable = true;

    flags = [
      "--ozone-platform=wayland"
      "--password-store=kwallet"
    ];

    policies = {
      "BrowserSignin" = 1;
      "PasswordManagerEnabled" = false;
      "SyncDisabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [ "en-US" ];
      "ExtensionInstallAllowlist" = [ "kfpeoanghcjibjecjfglenjnolokmfea" ];
    };
  };
}
