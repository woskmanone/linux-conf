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

  # Вмикаємо GRUB
  boot.loader.grub = {
    enable = true;          
    device = "nodev"; 
    efiSupport = true;      
    theme = pkgs.catppuccin-grub.override {
      flavor = "mocha"; 
    };
  };
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "nix-hplaptop"; # Define your hostname.
  networking.wireless.enable = true;  

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

  # Disable fucking X11 windowing system.
  services.xserver.enable = false;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."derypaskoms" = {
    isNormalUser = true;
    description = "Maksym Derypasko";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
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

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  #NN
  qdirstat unzip wget 
  #Networks
  inetutils 
  #Dev
  vscodium git fastfetch btop gcc 
  #Personal
  librewolf telegram-desktop rustdesk 
  ];

  # Enable virtualisation
   virtualisation.libvirtd.enable = true;
   programs.virt-manager.enable = true;

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  services.tailscale = {
    # Enable tailscale at startup
    enable = true;
  };

  # Install WinBox
   programs.winbox = {
   enable = true;
   openFirewall = true; 
};
  # Install Wireshark
   programs.wireshark.enable = true;
   programs.wireshark.package = pkgs.wireshark;

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ ];
   networking.firewall.allowedUDPPorts = [ ];
   networking.firewall.trustedInterfaces = [ "tailscale0" ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

#Enabling zram
zramSwap = {
  enable = true;
  algorithm = "zstd";
  memoryPercent = 50;
  priority = 100;
};

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = false;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.derypaskoms = {
    isNormalUser = true;
shell = pkgs.zsh;
    description = "Maksym Derypasko";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "wireshark" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };
#Enabling virtualisation
virtualisation.libvirtd.enable = true;
programs.virt-manager.enable = true;

  # Install firefox.
  programs.firefox.enable = false;

#Install WinBox
programs.winbox = {
  enable = true;
  openFirewall = true; # Відкриває порти для пошуку сусідів (UDP 5678)
};

#Install zsh.
programs.zsh = {
syntaxHighlighting.enable = true;
  enable = true;
promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
ohMyZsh = {
    enable = true;
    plugins = [ "git" "sudo" ]; # додайте потрібні плагіни
  };
};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

              nixpkgs.config.permittedInsecurePackages = [
                "ciscoPacketTracer8-8.2.2"
              ];
#Install Steam
programs.steam.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #Virtualisation
    qemu_kvm
    virt-manager
    virt-viewer
    #Networks
    ciscoPacketTracer8
    wireshark
    inetutils
    #SYS
    qdirstat
    unzip
    wget
    vim
    #DEV
    vscodium
    git
    fastfetch
    btop
    #Personal
    telegram-desktop
    google-chrome
    freeoffice
    zsh-powerlevel10k
];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  system.stateVersion = "25.11";

}
