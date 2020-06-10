This repository is no longer maintained and has been replaced with a web version, visit the new repository [here](https://github.com/tiffany352/unicode-visualizer-web) and the website [here](https://tiffnix.com/unicode/).

# Unicode Visualizer Plugin

<https://www.roblox.com/library/1085102904/Unicode-Visualizer>

A plugin to debug/visualize what's going on in a Unicode string. Shows
code units, codepoints, and graphemes. You can click on codepoints to
view detailed information about what they represent.

You can select any Instance in Studio and the magnifying glass menu in
the top right will show all the relevant strings it contains (Name,
Text, Value, etc. string properties).

The goal with this plugin is to be able to paste in a string you don't
understand and come out with a complete understanding of why it behaves
the way it does.

## Development Setup

1. Install Rojo and Hotswap.
2. Install dependencies via `git submodule update --init`.
3. Create a new place.
4. Set HTTP enabled in the Game Settings window.
5. Sync using Rojo.
6. Set the hotswap target to `ReplicatedStorage.UnicodeVisualizerPlugin` by selecting it in Studio and opening the Hotswap window.
7. Enter play solo.
8. In play solo, you can sync or toggle polling to update as you edit. It will hot reload without having to restart play solo.

### Updating src/Data/

1. Have lua 5.1
2. Download the latest version of UCD http://www.unicode.org/Public/UCD/latest/ucd/UCD.zip
3. Unzip it into `UCD/`
4. Run `lua build.lua`
