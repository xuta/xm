{ config, pkgs, lib, ... }:

let
  homePackages = import ./packages.nix { inherit pkgs; };
in

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
  home.packages = homePackages;

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

    # Don't put .tmux.conf here,
    # because you will need to rebuild home-manager before reloading tmux config
    # ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink home/.tmux.conf;
    # ".tmux.conf".source = home/.tmux.conf;

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

      xcopy() {
        xclip -selection clipboard
      }

      xpaste() {
        xclip -o -selection clipboard
      }

      # remove blank lines
      # accept both argument and stdin
      xremove_blank_line() {
        egrep -v "^[\t ]*$" "$@"
      }

      # remove comments
      # accept both argument and stdin
      xremove_comment() {
        egrep -v "^[\t ]*#" "$@"
      }
    '';
    shellAliases = {
      source-bashrc = "source ~/.bashrc";
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
      theme = "dracula_at_night";

      editor = {
        true-color = true;
        cursorline = true;
        bufferline = "always";
        rulers = [90 120];
        line-number = "relative";

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
          x = ":cd ~/workspace/xm";
          n = ":cd ~/workspace/nixin/laptop";
        };
        "=" = {
          h = ":open ~/workspace/xm/home.nix";
          c = ":open ~/workspace/nixin/laptop/configuration.nix";
        };
      };
    };
  };

  # programs.java.enable = true;

  # sample systemd service setup in user level
  # systemd.user.services = {
  #   sample-home = {
  #     Unit = {
  #       Description = "systemd for user level testing";
  #     };
  #     Install = {
  #       WantedBy = [ "default.target" ];
  #     };
  #     Service = {
  #       Type = "exec";
  #       ExecStart = "${pkgs.writeShellScript "sample-home" ''
  #         while true; do
  #           ${pkgs.coreutils}/bin/date >> /tmp/sample-home.log
  #           ${pkgs.coreutils}/bin/sleep 10
  #         done
  #       ''}";
  #     };
  #   };
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
