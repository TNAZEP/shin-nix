{
  flake.nixosModules.amd =
    { pkgs, ... }:
    {
      # Enable graphics acceleration
      hardware.graphics = {
        enable = true;
        enable32Bit = true;

        # Vulkan and OpenCL support
        extraPackages = with pkgs; [
          amdvlk
          rocmPackages.clr.icd
        ];
        extraPackages32 = with pkgs; [
          driversi686Linux.amdvlk
        ];
      };

      # Use the amdgpu driver
      services.xserver.videoDrivers = [ "amdgpu" ];

      # Ensure amdgpu kernel module loads early for proper modesetting
      boot.initrd.kernelModules = [ "amdgpu" ];

      # HIP support for GPU compute (useful for some applications)
      systemd.tmpfiles.rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];

      # Environment variables for AMD GPU
      environment.variables = {
        # Use RADV (Mesa) as default Vulkan driver - generally better performance
        AMD_VULKAN_ICD = "RADV";
      };
    };
}

