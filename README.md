# My NixOS & Home-manager configuration

## Preview
![Desktop](./assets/desktop.png)
Based on [nix-config](https://github.com/gvolpe/nix-config).

## Build

(Change the username in [outputs](outputs/home-conf.nix) to your actual system username)

### CLI only
#### Bootstrapping home manager
```console
# The profile shellhome contains only minimalist cli tools(no GUI), so it works non-NixOS distro too(need to have the Nix package manager installed) 
nix build github:KaminariOS/nix-flake-config/dev#homeConfigurations.shellhome.activationPackage --extra-experimental-features nix-command --extra-experimental-features flakes
result/activate
# Optional Nvim profile 
nix profile install github:KaminariOS/neovim-flake/dev --extra-experimental-features nix-command --extra-experimental-features flakes
```

#### With home manager installed
```console
# CLI only
home-manager switch --flake github:KaminariOS/nix-flake-config/dev#shellhome --extra-experimental-features nix-command --extra-experimental-features flakes
```

### GUI and full home config
```console
# Full GUI, replace kosumi with your username
home-manager switch --flake '/home/kosumi/nixpkgs#kosumi'
```

### NixOS system config 
```
# Replace thinker with your actual hostname
sudo nixos-rebuild switch --flake .#thinker
```

