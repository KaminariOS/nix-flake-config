{
  boot = {
    blacklistedKernelModules = ["ideapad_laptop"];
    initrd.kernelModules = ["amdgpu"];
    kernelModules = ["amdgpu"];
  };
}
