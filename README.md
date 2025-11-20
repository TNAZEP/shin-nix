# Shin-Nix

A modular, flake-based NixOS configuration designed for stability and ease of use. Managed with **Nix Flakes** and **Home Manager**.

## 📂 Structure

The repository is organized to separate concerns and promote reusability:

- **`hosts/`**: Configuration for specific machines.
    - **`midgar/`**: Desktop configuration (Nvidia 3070, KDE Plasma, Hyprland).
        - `configuration.nix`: System-level configuration.
        - `home.nix`: User-level configuration (Home Manager).
        - `disko.nix`: Disk partitioning layout.
- **`modules/`**: Reusable configuration blocks.
    - **`apps/`**: General application packages.
    - **`common/`**: Shared system settings (locale, time, experimental features).
    - **`hardware/`**: Hardware-specific configurations (e.g., `nvidia`).
    - **`roles/`**: Purpose-specific collections of modules.
        - **`desktop/`**: Desktop environment (KDE, SDDM) and Window Managers.
        - **`gaming/`**: Gaming setup (Steam, Faugus, Gamemode).
        - **`utilities/`**: Development tools (Zed, VSCodium).
- **`flake.nix`**: The entry point defining inputs and system outputs.

## 🚀 Installation

Follow these steps to install this configuration on a new machine (specifically targeting `midgar`).

### 1. Prepare the Environment
Boot into the NixOS installation media and switch to the root user:

```bash
sudo su
```

Clone this repository:

```bash
git clone https://github.com/yourusername/shin-nix.git
cd shin-nix
```

### 2. Partition the Disk (Disko)
> [!WARNING]
> This step will **FORMAT** the target disk (`/dev/nvme0n1` for midgar). Ensure you have backed up any important data.

Run Disko to partition, format, and mount the drives:

```bash
nix run github:nix-community/disko -- --mode disko ./hosts/midgar/disko.nix
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