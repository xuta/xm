{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "xuta";
  home.homeDirectory = "/home/xuta";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
  nixpkgs.config.allowUnfree = true;

  
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
    "electron-25.9.0"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    gcc
    unixtools.top
    htop
    ncdu
    unzip
    xz
    wget
    curl
    git
    vim
    xclip
    xorg.xkill

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
  ];

  home.activation = {
    tmux = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      setup_tmux() {
        echo "setup tmux"
        $DRY_RUN_CMD ln -nfs ${config.home.homeDirectory}/.config/home-manager/home/.tmux.conf ~/
      }
      
      [ -f ~/.tmux.conf ] || setup_tmux
    '';
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/xuta/etc/profile.d/hm-session-vars.sh
  #

  programs.dircolors.enable = true;
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      # Force reload ~/.profile for new interactive sessions
      test -f ~/.profile && unset __HM_SESS_VARS_SOURCED && source ~/.profile
      export PS1="\[\033[m\]|\[\033[1;35m\]\t\[\033[m\]|\[\e[1m\]\u\[\e[1;36m\]\[\033[m\]@\[\e[1;36m\]\h\[\033[m\]:\[\e[0m\]\[\e[1;32m\]\w > \[\e[0m\]"
      export PATH=$HOME/bin:$PATH
    '';
    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";

      xm = "cd ~xuta/workspace/xm";
      xme = "hx ~xuta/workspace/xm/home.nix";
      nixin = "cd ~xuta/workspace/nixin/laptop";
      thinkfan-info = "cat /proc/acpi/ibm/fan";
    };
  };


  programs.git = {
    enable = true;
    userName = "Xuta Le";
    userEmail = "xuta.le@gmail.com";
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
    ];
    defaultCommand = "fd --type f";
    fileWidgetOptions = [
      "--preview 'bat -n --color=always {}'"
    ];
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      # theme = "dracula";
      theme = "dracula_at_night";

      editor = {
        true-color = true;
        cursorline = true;
        bufferline = "always";
        rulers = [90 120];

        file-picker.hidden = false;
        soft-wrap.enable = true;
        cursor-shape.insert = "bar";
        statusline = {
          left = ["mode" "spinner" "file-name" "version-control" "read-only-indicator"];
          right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
        };
      };

      keys.normal = {
        space.space = "file_picker";
        "+" = {
          x = ":cd ~xuta/workspace/xm";
          n = ":cd ~xuta/workspace/nixin/laptop";
        };
        "=" = {
          h = ":open ~xuta/workspace/xm/home.nix";
          c = ":open ~xuta/workspace/nixin/laptop/configuration.nix";
        };
      };
    };
  };

  # programs.java.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
