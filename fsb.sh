sudo wget https://pkgs.tailscale.com/stable/fedora/tailscale.repo -P /etc/yum.repos.d/
sudo rpm-ostree install tailscale --apply-live
sudo systemctl enable --now tailscaled
sudo tailscale up
