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

## Development and Testing

### Building from Source

```powershell
choco pack
choco install dn-dosnav -s "." -y
```

### Testing with Sandboxie-Plus

When testing Chocolatey packages in Sandboxie-Plus, be aware that Chocolatey caches installed packages. To ensure you're testing the latest version after making changes:

1. **On the host machine**, delete the cached package directory:
   ```powershell
   Remove-Item -Recurse -Force "C:\Sandbox\<User>\<BoxName>\user\all\chocolatey\lib\dn-dosnav" -ErrorAction SilentlyContinue
   ```

2. **Inside the sandbox**, rebuild and reinstall:
   ```powershell
   choco uninstall dn-dosnav -y
   choco pack
   choco install dn-dosnav -s "." -y --force
   ```

**Helper script** - Create `test-install.ps1` for faster iteration:

```powershell
# Clean up completely
choco uninstall dn-dosnav -y 2>$null
Remove-Item -Recurse -Force "$env:ChocolateyInstall\lib\dn-dosnav" -ErrorAction SilentlyContinue

# Build fresh package
choco pack

# Install from local source
choco install dn-dosnav -s "." -y --force
```

**Why this is necessary:** Chocolatey's `--force` flag reinstalls the package but doesn't always clear the cached files, especially in sandboxed environments. Changes to `chocolateyinstall.ps1` won't take effect until the cache is manually cleared.

### Testing in Sandboxie-Plus (Safe Environment)

To avoid modifying your host system during testing, you can use **Sandboxie-Plus** to install and run the Chocolatey package in an isolated sandbox.

#### Steps

1. **Create a new sandbox** (example: `DNTest`) from the Sandboxie-Plus GUI or command line.
   ```powershell
   "C:\Program Files\Sandboxie-Plus\Start.exe" /box:DNTest powershell.exe
````

2. **Inside the sandboxed PowerShell**, install your local package:

   ```powershell
   cd C:\path\to\repo
   choco pack
   choco install dn-dosnav -s "." -y
   ```

3. **Run DN**:

   ```powershell
   dn
   ```

   This will launch DOS Navigator inside DOSBox-X, with your working directory mounted as **C:**.

#### Why use Sandboxie-Plus?

* Prevents unwanted changes to your host Chocolatey installation or PATH.
* Allows repeatable, disposable test environments.
* Lets you validate installation scripts, dependencies, and shims as if on a fresh Windows system.

> 💡 Tip: If you change `chocolateyinstall.ps1`, remember Chocolatey caches package files. Clear the sandbox cache (`C:\Sandbox\<User>\<BoxName>\user\all\chocolatey\lib\dn-dosnav`) or use `--force` to ensure updates take effect.

## License

DOS Navigator is created by RITLabs. Package maintained by Foadsf.

## Links

- [Package on Chocolatey](https://community.chocolatey.org/packages/dn-dosnav)
- [Source Repository](https://github.com/Foadsf/dn-dosnav-chocolatey)
- [DOS Navigator Official Site](https://www.ritlabs.com/download/dn/)
