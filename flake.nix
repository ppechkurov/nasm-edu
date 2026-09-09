{
  description = "NASM learing flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      with pkgs;
      {
        # Development environment output
        devShells = {
          default = mkShell {
            packages = [
              asm-lsp
              nasm
              nasmfmt
              watchexec
              gnumake
            ];
          };
        };
      }
    );
}
