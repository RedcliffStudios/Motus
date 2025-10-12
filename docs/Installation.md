---
sidebar_position: 2
---

# Installation

### Method 1 - Package Manager (Wally)

Using Wally, just add `motus = "notkaif/motus@1.0.3"` to your wally.toml
Then run

```sh
 wally install
```

 in the command line!

- Need the Luau types?
- Using `wally-package-types` run

```sh
wally-package-types --sourcemap sourcemap.json Packages/
```

### Method 2 - Manual

1. Visit the [latest release](https://github.com/RedcliffStudios/Motus/releases/latest)
2. Under *Assets*, click `Motus.lua`
3. - Using [Rojo](https://rojo.space/)? Put the file into your game directly.
   - Using Roblox Studio? Open the file, copy its contents, and paste into a ModuleScript and call it `Motus`.