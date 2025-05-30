{
  description = "rebeagle nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      sops-nix,
    }:
    let
      system = "x86_64-linux";
      commonSpecialArgs = {
        inherit disko self;
      };
      commonModules = [
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
      ];
    in
    {
      nixosConfigurations = {
        hopper = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs;
          modules = [
            ./hosts/hopper
            ./hosts/hopper/hardware.nix
          ] ++ commonModules;
        };
        turing = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs;
          modules = [
            ./hosts/turing
            ./hosts/turing/hardware.nix
          ] ++ commonModules;
        };
        beck = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs;
          modules = [
            ./hosts/beck
            ./modules/hardware/virtual.nix
          ] ++ commonModules;
        };
        turingv = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = commonSpecialArgs;
          modules = [
            ./hosts/turingv
            ./modules/hardware/virtual.nix
          ] ++ commonModules;
        };
      };
    };
}
