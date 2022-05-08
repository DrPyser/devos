{ self, config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  # Sets nrdxp.cachix.org binary cache which just speeds up some builds
  imports = [ ../cachix ];

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
  };

  # This is just a representation of the nix default
  nix.systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

  environment = {

    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      dash
      binutils
      coreutils
      curl
      direnv
      dnsutils
      dosfstools
      fd
      git
      bottom
      gptfdisk
      iputils
      jq
      manix
      moreutils
      nix-index
      nmap
      ripgrep
      skim
      tealdeer
      usbutils
      utillinux
      whois
      # editor
      kakoune
      starship
    ];

    # Starship is a fast and featureful shell prompt
    # starship.toml has sane defaults that can be changed there
    shellInit = ''
      export STARSHIP_CONFIG=${
        pkgs.writeText "starship.toml"
        (fileContents ./starship.toml)
      }
    '';

    shellAliases =
      let ifSudo = lib.mkIf config.security.sudo.enable;
      in
      {
        # quick cd
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        # git
        g = "git";

        # grep
        grep = "rg";
        gi = "grep -i";

        # internet ip
        myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";

        # nix
        n = "nix";
        np = "n profile";
        ni = "np install";
        nr = "np remove";
        ns = "n search --no-update-lock-file";
        nf = "n flake";
        nepl = "n repl '<nixpkgs>'";
        srch = "ns nixos";
        orch = "ns override";
        nrb = ifSudo "sudo nixos-rebuild";
        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';

        # fix nixos-option
        nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

        # sudo
        s = ifSudo "sudo -E ";
        si = ifSudo "sudo -i";
        se = ifSudo "sudoedit";

        # top
        top = "btm";

        # systemd
        ctl = "systemctl";
        stl = ifSudo "s systemctl";
        utl = "systemctl --user";
        ut = "systemctl --user start";
        un = "systemctl --user stop";
        up = ifSudo "s systemctl start";
        dn = ifSudo "s systemctl stop";
        jtl = "journalctl";

      };
    variables = {
      TERM = "xterm-256color";
      TERMINAL = "alacritty";
      # perhaps better set this in user session variables
      EDITOR = "${pkgs.kakoune}/bin/kak";
      # AGENDA = "~/.agenda.org";
      # # AGENDACMD = "${pkgs.kakoune}/bin/kak -s agenda ${config.environment.variables.AGENDA}";
    };
    binsh = "${pkgs.dash}/bin/dash";
  };

  fonts = {
    # TODO install nerdfonts e.g. FiraCode
    fonts = with pkgs; [
      powerline-fonts
      dejavu_fonts
      (nerdfonts.override {
        fonts = [ "FiraCode" "DroidSansMono" ];
      })
    ];

    fontconfig.defaultFonts = {

      monospace = [ "FuraCode Nerd Font Mono" ];

      sansSerif = [ "DejaVu Sans" ];

    };
  };

  nix = {

    # Improve nix store disk usage
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;

    # Prevents impurities in builds
    useSandbox = true;

    # give root and @wheel special privileges with nix
    trustedUsers = [ "root" "@wheel" ];

    # Generally useful nix option defaults
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';

  };
  # shell config, could extra to separate profile
  programs.fish = {
    enable = true;
    vendor.config.enable = true;
    vendor.completions.enable = true;
    vendor.functions.enable = true;
    interactiveShellInit = ''
      starship init fish | source
      direnv hook fish | source
      any-nix-shell fish | source
      # atuin shell history. configured through home manager user profiles.
    '';
    loginShellInit = ''
      # log into default tmux session
      if not set -q TMUX
        # replace login shell with tmux session
        exec tmux new -t login -A -s login\; \
        # tmux session setup configured through tmux user service in tmux profile
      end
    '';
    promptInit = ''
      set -l nix_shell_info (
        if test -n "$IN_NIX_SHELL"
          echo -n "<nix-shell> "
        end
      )
      set_color normal
      echo -n -s "$nix_shell_info ~>"
    '';
  };

  # alternative shell config
  programs.bash = {
    # Enable starship
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    # Enable direnv, a tool for managing shell environments
    interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

  # tmux config here?

  # Service that makes Out of Memory Killer more effective
  services.earlyoom.enable = true;

}
