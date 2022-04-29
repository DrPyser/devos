{ config, pkgs, ... }@inputs:
let
  stdenv = pkgs.stdenv;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "drpyser";
  home.homeDirectory = "/home/drpyser";

  # TODO: overlay to add packages to pkgs

  # user session environment
  home.sessionVariables = {
    EDITOR = "${pkgs.kakoune}/bin/kak";
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
  };

  # 
  home.packages = [
    pkgs.nixfmt
    # replace with custom editor package
    #pkgs.kakoune
    # lorri daemon setup in system config
    pkgs.lorri
    # knowledge management tool
    # pkgs.nb
    #
    pkgs.weechat
    pkgs.weechatScripts.weechat-matrix

    pkgs.bat
    pkgs.ranger

    # pkgs.zathura.withPlugins (plugins: {
    #   plugins = [];
    # })
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "21.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.enable = true;
  # see https://nixos.wiki/wiki/Kakoune for alternative way to create custom package with configuration and plugins.
  programs.kakoune = {
    enable = true;
    # see what is worth putting here
    config = {
      colorScheme = "gruvbox-dark";
      hooks = [ ];
      autoReload = "yes";
      keyMappings = [ ];
      numberLines = {
        enable = true;
        highlightCursor = true;
      };
      showMatching = true;
      showWhitespace = {
        enable = true;
      };
      tabStop = 4;
      ui = {
        enableMouse = true;
        assistant = "dilbert";
        setTitle = true;
      };
      wrapLines = {
        enable = true;
        indent = false;
        marker = "⏎";
        word = true;
      };

    };
    plugins = [
      # could clean this up and split out package spec in separate file
      # based on plugin packaging in nixpkgs repo:
      #  https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/kakoune/plugins/build-kakoune-plugin.nix
      (
        let
          pluginDirectory = "share/kak/autoload/plugins";
        in
        stdenv.mkDerivation rec {
          pname = "plug.kak";
          version = "d2bde86";
          src = pkgs.fetchFromGitHub {
            owner = "andreyorst";
            repo = "plug.kak";
            rev = "d2bde869b077988e1c1e6f05ab94a485366516f8";
            sha256 = "WK96PRnofyBnS6PH4xeJSNJdVdcApGZ//4GPBKvYATg=";
          };
          installPhase = ''
            target=$out/${pluginDirectory}/${pname}
            mkdir -p $out/${pluginDirectory}
            cp -r . $target
          '';
        }
      )
    ];
    extraConfig = (builtins.readFile (./. + "/kak/kakrc.src"));
  };

  # plugins installed separately from nix(raw git clone, plug.kak) are symlinked into custom plugin directory
  # TODO: this should be unecessary if plugins are all configured here.
  home.file.".config/kak/plugins" = {
    recursive = false;
    source = ./. + "/kak/plugins";
  };
  #home.file.".config/kak/autoload/standard-library" = {
  #    recursive = false;
  #    source = pkgs.kakoune + "/share/kak/autoload";
  #};

  programs.lsd.enable = true;
  programs.lsd.enableAliases = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
    nix-direnv.enableFlakes = true;
  };

  programs.fish = {
    enable = true;
    loginShellInit = ''
      # log into default tmux session
      if not set -q TMUX
        # tmux new -t login -A -s login\;\
        tmux neww -t login:agenda -s -n agenda kak $AGENDA
      end
    '';
  };

  # user session services
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # other managed files
  home.file.i3exit = {
    source = ./. + "/i3/i3exit.sh";
    target = "bin/i3exit";
    executable = true;
  };
  # windows manager configured in system profile, but config managed here in user profile
  # TODO: should graphical session and WM be configured here or through system conf?
  xdg.configFile."i3/config" = {
    source = ./. + "/i3/config";
  };
  # xsession.windowManager.i3 = {
  #   enable = true;
  #   extraConfig = (builtins.readFile (configRoot + "/i3/.config/i3/config"));
  # };

  # TODO: configure email client to access and manage mails
  accounts.email.accounts = {
    main = {
      primary = true;
      address = "self@charleslanglois.dev";
      aliases = [
        "me@charleslanglois.dev"
        "moi@charleslanglois.dev"
      ];
    };
    gmail = {
      address = "schok53@gmail.com";
    };
    protonmail = {
      address = "drpyser@pm.me";
      aliases = [
        "drpyser@protonmail.com"
      ];
    };
  };

}
