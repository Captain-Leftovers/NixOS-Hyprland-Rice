{ ... }:
{
  imports = [
    ./ripgrep.nix # better grep ( alias added grep = "rg")
    ./aseprite/aseprite.nix # pixel art editor
    ./audacious.nix # music player
    ./bat.nix # better cat command
    ./browser.nix # firefox based browser
    ./btop.nix # resouces monitor
    ./cava.nix # audio visualizer
    ./discord.nix # discord
    ./fastfetch.nix # fetch tool
    ./flow.nix # terminal text editor
    ./fzf.nix # fuzzy finder
    ./gaming.nix # packages related to gaming
    ./ghostty.nix # terminal
    ./git.nix # version control
    ./gnome.nix # gnome apps
    ./gtk.nix # gtk theme
    ./hyprland # window manager
    ./kitty.nix # terminal
    ./lazygit.nix
    ./micro.nix # nano replacement
    ./nemo.nix # file manager
    ./nix-search/nix-search.nix # TUI to search nixpkgs
    ./obsidian.nix
    ./p10k/p10k.nix
    ./packages # other packages
    ./retroarch.nix
    ./rofi.nix # launcher
    ./scripts/scripts.nix # personal scripts
    ./ssh.nix # ssh config
    ./superfile/superfile.nix # terminal file manager
    ./swaylock.nix # lock screen
    ./swayosd.nix # brightness / volume wiget
    ./swaync/swaync.nix # notification deamon
    ./taskwarrior.nix   # todo / task cli

    ./neovim        # Neovim Folder with cnfg inside
    
    # ./viewnior.nix                  # image viewer
    # ./vscodium                      # vscode fork
    ./vscode # official VsCode
    ./waybar # status bar
    ./waypaper.nix # GUI wallpaper picker
    ./xdg-mimes.nix # xdg config
    ./zsh # shell
    ./expressvpn.nix # ExpressVPN auto connect service
    ./gammastep.nix # control bluelight/redlight
  ];
}
