{ self, config, pkgs, ... }:
{
  sops.defaultSopsFile = "${self}/private/secrets/client.prod.yaml";
  sops.secrets.will-password.neededForUsers = true;

  users.users.will = {
    isNormalUser = true;
    description = "Will";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    hashedPasswordFile = config.sops.secrets.will-password.path;
  };
  
  environment.systemPackages = with pkgs; [
    vscode
  ];
}
