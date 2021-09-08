{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  inherit (lib) optional optionals;
  # https://til.codes/nix-shell-for-elixir-projects/
  # erlang = beam.interpreters.erlangR22;
  # elixir = beam.packages.erlangR22.elixir_1_10;
  # rebar = beam.packages.erlangR22.rebar3;

  elixir = unstable.elixir;
  erlang = unstable.erlang;
  # https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#elixirls
  # https://github.com/elixir-lsp/elixir-ls#building-and-running
  elixir_ls = unstable.elixir_ls;
  rebar = unstable.rebar3;

in

mkShell {
  buildInputs = [ elixir elixir_ls erlang rebar ];

  shellHook = ''

    # https://ghedam.at/15443/a-nix-shell-for-developing-elixir
    # this allows mix to work on the local directory
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    # https://github.com/fly-apps/hello_elixir-dockerfile/blob/main/Dockerfile
    export MIX_ENV=dev #prod
    
    # livebook
    #PATH=$HOME/.../elixir/tests/.../.nix-mix/escripts:$PATH
    
    # https://github.com/elixir-lang/elixir/wiki/FAQ#31-how-to-have-my-iex-session-history-to-be-persistent-over-different-iex-sessions
    # https://hexdocs.pm/iex/IEx.html#module-shell-history
    export ERL_AFLAGS="-kernel shell_history enabled"
    # https://elixirforum.com/t/compilation-warnings-clause-cannot-match-in-mix-and-otp-tutorial/25114/9
    unset $ERL_LIBS
    export LANG=en_US.UTF-8
  '';
}
