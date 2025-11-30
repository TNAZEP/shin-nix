# Shin-Nix

A modular, flake-based NixOS configuration designed for stability and ease of use. Managed with **Nix Flakes** and **Home Manager**.

## Hosts

|     | Hostname   | OS   			| Board            | CPU                | RAM   | GPU                       | Purpose                                                                          |
| --- | ---------- | -------------- | ---------------- | ------------------ | ----- | ------------------------- | -------------------------------------------------------------------------------- |
| 🖥️  | `midgar`   | NixOS	        | Asus		       | Ryzen 7 5800X3D    | 32GB  | RX 9070XT / RTX 3070	    | Main Desktop for general use, development and gaming.		                       |
| 💻  | `ishgard`  | MacOS 26		| Apple M1 air	   | M1 8C		        | 8 GB  | M1 7C	                    | General use, light development and media consumption.                            |
| 💻  | `lestallum`  | NixOS		| HP Prodesk G5	   | intel Core i5 9500	        | 15 GB  | Intel UHD 630	                    | Home Server                            |

## 🚀 Installation

Follow these steps to install this configuration on a new machine (specifically targeting `midgar`, my desktop config).

### 1. Prepare the Environment
Boot into the NixOS installation media and switch to the root user:

```bash
sudo su
```

Clone this repository:

```bash
git clone https://github.com/tnazep/shin-nix.git
cd shin-nix
```

### 2. Partition the Disk (Disko)
> [!WARNING]
> This step will **FORMAT** the target disk (`/dev/nvme0n1` for midgar). Ensure you have backed up any important data.

Run Disko to partition, format, and mount the drives:

```bash
nix run github:nix-community/disko -- --mode disko ./modules/hosts/midgar/_disko.nix
```

### 3. Install NixOS
Install the system using the flake configuration:

```bash
nixos-install --flake .#midgar
```

### 4. Set Passwords
Enter the new system to set passwords for the root user and your user (`tnazep`):

```bash
# Set root password
nixos-enter --root /mnt -c 'passwd root'

# Set user password
nixos-enter --root /mnt -c 'passwd tnazep'
```

### 5. Finish
Reboot into your new system:

```bash
reboot
```