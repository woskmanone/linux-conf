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
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

  # Use LTS kernel.
  boot.kernelPackages = pkgs.linuxPackages;
  
  #Enabling zram
  zramSwap = {
     enable = true;
     algorithm = "zstd";
     memoryPercent = 75;
     priority = 100;
 };

  networking.hostName = "router-nix";

  # Enable networking
  systemd.network.enable = true;

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


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."derypaskoms" = {
    isNormalUser = true;
    description = "Maksym Derypasko";
    extraGroups = [ "networkmanager" "wheel" "libvirt" "wireshark" "kvm" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  services.frr = {
    enable = true;
    # Enable the individual routing daemons you need
    ospfd.enable = true;
    bgpd.enable = true;
    eigrpd.enable = true;
    staticd.enable = true;
  };

  networking.nftables.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = false;

  environment.systemPackages = with pkgs; [
  #NN
  unzip wget parted inetutils nmap dig git fastfetch btop tmux tcpdump iproute2 ethtool conntrack-tools wireguard-tools dnsmasq
  ];

  # Enable containerization
   #virtualisation.podman.enable = true;

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  services.tailscale = {
    # Enable tailscale at startup
    enable = true;
  };

  # Open ports in the firewall.
   #networking.firewall.allowedTCPPorts = [ ];
   #networking.firewall.allowedUDPPorts = [ ];
   #networking.firewall.trustedInterfaces = [ "tailscale0" ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
