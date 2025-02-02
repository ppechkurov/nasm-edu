{
  description = "NASM learing flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in with pkgs; {
        # Development environment output
        devShells = {
          default =
            mkShell { packages = [ asm-lsp nasm nasmfmt watchexec gnumake ]; };
        };

        # Binary
        packages.default = buildGo123Module rec {
          pname = "hello";
          version = "0.0.0";
          src = ./.;
          vendorHash = "fake-sha";
          nativeBuildInputs = [ installShellFiles ];
          # See [link](https://pkg.go.dev/cmd/link) for details. These are the same as in Makefile, but for Nix.
          ldflags = [
            "-s" # no debug
            "-w"
            "-X github.com/PafuPlex/sf-metadata-broker/backend/internal/version.Version=${version}"
            "-X github.com/PafuPlex/sf-metadata-broker/backend/internal/version.GitCommit=${self.rev}"
          ];

          # Uncomment when cli is ready
          # postInstall = # bash
          #   ''
          #     installShellCompletion --cmd ${pname} --zsh <($out/bin/${pname} completion zsh)
          #   '';
        };
      });
}
