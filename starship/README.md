# Starship

Starship uses `starship/starship.toml` through the Bash and PowerShell
configurations. A Nerd Font is recommended for its icons.

## Windows

### Install

Run in an elevated PowerShell session:

```powershell
winget install --id Starship.Starship --exact --scope machine
```

### Configure

Complete `powershell/README.md`; it sets `STARSHIP_CONFIG` automatically.

## Ubuntu

### Install

```sh
sudo apt update
sudo apt install -y starship
```

### Configure

Complete `bash/README.md`; it initializes Starship automatically.

## Omarchy

### Install

```sh
sudo pacman -S --needed starship
```

### Configure

Complete `bash/README.md`; it initializes Starship automatically.
