{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Localization config
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "br-abnt2";
  };

  # Network config
  networking.hostName = "felipe-laptop";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ ];
  };

  # System packages
  environment.enableAllTerminfo = true;
  environment.systemPackages = with pkgs; [
    jq wget git curl stow zsh tmux ripgrep python3 rsync rclone dig gcc parted neovim htop gnumake emacs keychain
    swaybg swayidle swaylock waybar foot firefox gnome.adwaita-icon-theme gnome.nautilus fuzzel pavucontrol
    mako grim slurp gnome.file-roller mpv wl-clipboard acpi networkmanagerapplet zathura lxappearance
    discord spotify
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  fonts.fonts = with pkgs; [
    dejavu_fonts
    ibm-plex
    noto-fonts
    font-awesome
    cantarell-fonts
  ];

  programs.light.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.felipe = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODYM21KhCY0j5H54ojTvXZn0Nx/z4nbqPCE6EzCTPRq"
    ];
  };

  # Audio
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
  };

  # Power
  services.tlp.enable = true;

  # Enable SSH
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Tailscale
  services.tailscale.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "extra-experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      # Every Monday 01:00 (UTC)
      dates = "Monday 01:00 UTC";
      options = "--delete-older-than 7d";
    };
  };
  
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

