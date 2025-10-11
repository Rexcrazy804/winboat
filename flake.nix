{
  description = "WinBoat - Run Windows apps on Linux with seamless integration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    self' = self.packages.${system};
  in {
    packages.${system} = {
      winboat-guest-server = pkgs.callPackage ./nix/guest.nix {inherit (self') winboat;};
      winboat = pkgs.callPackage ./nix/package.nix {inherit (self') winboat-guest-server;};
      default = self'.winboat;
    };

    nixosModules = {
      winboat = {
        imports = [./nix/module.nix];
        services.winboat.package = self'.default;
      };
      default = self.nixosModules.winboat;
    };
  };
}
