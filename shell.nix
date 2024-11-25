{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    # Rust
    pkgs.cargo
    pkgs.rustc

    # OpenSSL
    pkgs.openssl
    pkgs.pkg-config
    pkgs.perl

    # Shell
    pkgs.zsh
    pkgs.zsh-powerlevel10k
    pkgs.oh-my-zsh
    # Include any additional dependencies required by your Zsh configuration
    pkgs.git
    pkgs.curl
  ];

  # Environment variables for OpenSSL
  OPENSSL_DIR = "${pkgs.openssl.dev}";
  OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
  OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";

  shellHook = ''
    export SHELL=${pkgs.zsh}/bin/zsh
    export NIX_SHELL_PRESERVE_PROMPT=1
    exec ${pkgs.zsh}/bin/zsh -l
  '';
}
