# dn-dosnav - DOS Navigator for Windows

A Chocolatey package that installs DOS Navigator 1.51 with a launcher that automatically starts it in DOSBox-X.

## Installation

```powershell
choco install dn-dosnav
```

## Usage

Navigate to any directory and run:

```cmd
dn
```

DOS Navigator will launch in DOSBox-X with:
- **C:** mounted to your current working directory
- **D:** mounted to the DN installation directory

## Requirements

- DOSBox-X (automatically installed as a dependency)

## Features

- Dual-pane file manager
- Full DOS Navigator 1.51 functionality
- Automatic directory mounting
- Portable - works from any location

## Building from Source

```powershell
choco pack
choco install dn-dosnav -s "." -y
```

## License

DOS Navigator is created by RITLabs. Package maintained by [Your Name].
