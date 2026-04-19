# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enabling GRUB
  boot.loader.grub = {
    enable = true;          
    device = "nodev"; 
    efiSupport = true;      
    theme = pkgs.catppuccin-grub.override {
      flavor = "mocha"; 
    };
  };
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;
  
  # Enabling auto updating
  system.autoUpgrade.enable = true;

  # Enabling zram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  networking.hostName = "nix-hplaptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

  # ==========================================
  # SWAY & WAYLAND КОНФІГУРАЦІЯ
  # ==========================================

  # Увімкнення Sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Сумісність з GTK-додатками
  };

  # Форсуємо використання Wayland для Electron (VSCodium) та Chrome
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # XDG Portals (критично для захоплення екрану у Chrome/Telegram)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Консольний менеджер входу (замість LightDM/XFCE)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  # Polkit (необхідний для запиту пароля root у графічних додатках типу virt-manager)
  security.polkit.enable = true;

  # ==========================================

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users.derypaskoms = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Maksym Derypasko";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "wireshark" "ubridge" ];
  };

  # Install firefox.
  programs.firefox.enable = false;
  
  # Enabling virtualisation
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Install WinBox
  programs.winbox = {
    enable = true;
    openFirewall = true; # Відкриває порти для пошуку сусідів (UDP 5678)
  };

  # Install zsh.
  programs.zsh = {
    syntaxHighlighting.enable = true;
    enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install Steam
  programs.steam.enable = true;

  # Install Wireshark
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Wayland / Sway інструментарій
    waybar           # Панель
    wofi             # Лаунчер додатків
    swaybg           # Встановлення шпалер
    swaylock         # Блокування екрану
    swayidle         # Менеджер простою
    mako             # Демон сповіщень
    wl-clipboard     # Буфер обміну для Wayland
    grim             # Скріншоти
    slurp            # Вибір зони екрану для скріншотів
    foot             # Легкий Wayland-нативний термінал (обов'язково потрібен для Sway)
    polkit_gnome     # Графічний агент авторизації
    pavucontrol
    swappy

    # Virtualisation
    qemu_kvm
    virt-manager
    virt-viewer
    
    # Networks
    
    inetutils
    
    # SYS
    qdirstat
    unzip
    wget
    vim
    
    # DEV
    vscodium
    git
    fastfetch
    btop
    gcc
    
    # Personal
    telegram-desktop
    google-chrome
    freeoffice
    zsh-powerlevel10k
  ];

  system.stateVersion = "25.11"; 
}
