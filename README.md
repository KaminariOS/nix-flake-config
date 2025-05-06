# My NixOS & Home-manager configuration

Based on [nix-config](https://github.com/gvolpe/nix-config).

## Build

(Change the username in [outputs](outputs/home-conf.nix) to your username)

### CLI only
#### Bootstrapping home manager
```console
nix build github:KaminariOS/nix-flake-config/dev#homeConfigurations.shellhome.activationPackage --extra-experimental-features nix-command --extra-experimental-features flakes
result/activate

```

#### With home manager installed
```console
home-manager switch --flake github:KaminariOS/nix-flake-config/dev#shellhome --extra-experimental-features nix-command --extra-experimental-features flakes
```
