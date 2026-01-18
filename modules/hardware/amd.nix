{
  flake.nixosModules.amd =
    { ... }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      hardware.amdgpu = {
        # Load amdgpu kernel module early in initrd
        initrd.enable = true;
        # Enable OpenCL support via ROCm
        opencl.enable = true;
      };

      services.xserver.videoDrivers = [ "amdgpu" ];
    };
}

