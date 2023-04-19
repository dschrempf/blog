{
  description = "Blog development environment";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = with pkgs; pkgs.mkShell {
          packages = [
            # See https://github.com/NixOS/nixpkgs/issues/59209.
            bashInteractive

            hugo
          ];
        };
      }
    );
}
