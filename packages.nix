{ pkgs, ... }:

with pkgs; [
    gcc
    unixtools.top
    htop
    file
    ncdu
    unzip
    xz
    wget
    curl
    git
    vim
    xclip
    xorg.xkill

    # Nix
    nixos-shell # visualization
    nvd  # diff build versions
    nil  # Nix language server
    comma # Run software without installing it https://github.com/nix-community/comma

    lazygit
    delta  # diff tool
    bat
    jq
    fd
    ripgrep
    ranger
    lf
    tmux

    hugo  # website framework for markdown
    syncthing
    syncthingtray
    anki-bin
    mpv  # for audio in Anki
    google-chrome
    firefox
    meld
    spotify
    vlc
    slack
    sublime4
    sublime-merge
    vscode
    obsidian
    transmission_4-qt
    telegram-desktop
    zoom-us
    citrix_workspace

    calibre

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
]
