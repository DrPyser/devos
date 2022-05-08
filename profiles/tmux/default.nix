{ self, config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  ## tmux
  # extract to tmux profile
  programs.tmux = {
    enable = true;
    shortcut = "a";
    aggressiveResize = true;
    baseIndex = 1;
    # newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    terminal = "screen-256color";

    extraConfig = ''
      # Mouse works as expected
      set-option -g mouse on
      # set-option -s escape-time 0
      set-option -g history-limit 50000
      set-option -g display-time 4000
      set-option -g status-interval 5
      # set-option -g default-terminal "screen-256color"
      set-option -g default-shell "''${SHELL}"
      set-option -g default-command "''${SHELL}"
      # set-window-option -g aggressive-resize on
      set-option -g focus-events on
      set-option -g status-keys emacs
      set-option -g prefix2 C-`
      # copy to clipboard
      set-option -g copy-command "xsel -b -i"
      set-option -g exit-empty off
      set-option -g exit-unattached off
      set-option -g set-clipboard on
      unbind-key a
      unbind-key C-a
      bind-key C-a send-prefix
      bind-key C-` send-prefix -2
      bind-key l last-window
      bind-key C-p previous-window
      bind-key C-n next-window
      bind-key C-k confirm-before -p "kill-server? (y/n)" kill-server
      # easy-to-remember split pane commands


      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      bind r source-file /etc/tmux.conf\;\
        display-message "Reloaded configurations"
      bind R refresh-client

      # new -A -s admin -d
      # neww -S -n monitoring -t admin monitoring htop

      source-file -q ~/.tmux.conf
    '';
  };

  # systemd service to start tmux server as early as possible
  # TODO: would be more useful to start session with specific configuration
  systemd.services.tmux = {
    wantedBy = [ "multi-user.target" ];
    #      after = [ "default.target" ];
    description = "tmux server process";
    environment = {
      TMUX_CONF = "/etc/tmux.conf";
      SHELL = "${pkgs.fish}/bin/fish";
      TMUX_LOGIN_CONF = builtins.toString ./login.conf;
    };
    reload = ''
      ${pkgs.tmux}/bin/tmux source-file $${TMUX_CONF}
    '';
    serviceConfig = {
      Type = "forking";
      ExecStart = ''
        ${pkgs.tmux}/bin/tmux start-server\;\
        source-file $$TMUX_LOGIN_CONF
      '';
      ExecStop = ''
        ${pkgs.tmux}/bin/tmux kill-server
      '';
    };
    enable = true;
  };

  environment.variables = {
    TMUX_TERMINAL_CONF = builtins.toString ./terminal.conf;
  };
}
