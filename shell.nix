{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    # Rust
    cargo
    rustc

    # OpenSSL
    openssl
    pkg-config

    # Build tools
    binutils
    gcc
    clang           # Provide an alternative compiler
    llvm            # Include lld and LLVM utilities
    lld             # Ensure lld is explicitly included

    # Shell
    zsh
    zsh-powerlevel10k
    oh-my-zsh

    # Additional utilities
    git
    curl
  ];

  shellHook = ''
    export SHELL=${zsh}/bin/zsh
    export NIX_SHELL_PRESERVE_PROMPT=1

    # Set environment variables for OpenSSL explicitly
    export CC=$(which clang)  # Use clang instead of gcc
    export CXX=$(which clang++)  # Use clang++ instead of g++
    export LD=$(which lld)  # Use LLVM's lld for linking
    export OPENSSL_DIR=${openssl.dev}
    export OPENSSL_LIB_DIR=${openssl.out}/lib
    export OPENSSL_INCLUDE_DIR=${openssl.dev}/include

    # Force Rust to use clang and lld
    export RUSTFLAGS="-C linker=$(which clang) -C link-arg=-fuse-ld=lld"

    # Add OpenSSL library to runtime path
    export LD_LIBRARY_PATH=${openssl.out}/lib:$LD_LIBRARY_PATH

    exec ${zsh}/bin/zsh -l
  '';
}
