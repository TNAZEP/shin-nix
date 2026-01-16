{
  flake.nixosModules.amd =
    { pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      hardware.amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
      };

      services.xserver.videoDrivers = [ "amdgpu" ];

      systemd.tmpfiles.rules =
        let
          rocmEnv = pkgs.symlinkJoin {
            name = "rocm-combined";
            paths = with pkgs.rocmPackages; [ rocblas hipblas clr ];
          };
        in
        [ "L+    /opt/rocm   -    -    -     -    ${rocmEnv}" ];
    };
}

