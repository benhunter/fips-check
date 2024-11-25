{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.openssl        # OpenSSL library
    pkgs.pkg-config     # Helps cargo find OpenSSL
    pkgs.perl           # Required by OpenSSL build scripts
    pkgs.rustc          # Rust compiler
    pkgs.cargo          # Rust package manager
  ];

  # Environment variables to help cargo and pkg-config locate OpenSSL
  OPENSSL_DIR = "${pkgs.openssl.dev}";
  OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
  OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
}
