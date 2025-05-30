{ self, config, ... }:
{
  sops.defaultSopsFile = "${self}/private/secrets/test.yaml";
  sops.secrets.test-password.neededForUsers = true;

  users.users.test = {
    isNormalUser = true;
    description = "Test User";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    hashedPasswordFile = config.sops.secrets.test-password.path;
  };
}
