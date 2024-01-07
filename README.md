# xm

## Quick start

```bash
nix-shell -p git
cd ~/workspace/
mkdir xm
cd xm
nix run home-manager/master -- init --switch ./
home-manager switch --flake ./
```