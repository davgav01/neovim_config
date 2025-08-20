# Jupyter Notebook Setup for Neovim

This setup follows the comprehensive guide from [Notebook-Setup.md](./Notebook-Setup.md) and provides a complete Jupyter notebook experience in Neovim using molten-nvim, quarto-nvim, and jupytext.nvim.

## Overview

This configuration provides:
- **Code running and output viewing** with `molten-nvim`
- **LSP features** (autocomplete, go to definition, etc.) in code cells via `quarto-nvim` and `otter.nvim`
- **File format conversion** between `.ipynb` and markdown via `jupytext.nvim`
- **Image display** with `image.nvim`
- **Automatic output import/export** when opening/saving notebooks

## Prerequisites

1. **Python environment** with Jupyter installed:
   ```bash
   # Run the installation script:
   ./install_jupyter_deps_brew.sh
   ```

2. **Terminal with image support** (Ghostty recommended):
   - Ghostty supports the kitty graphics protocol for image display
   - Alternative terminals: Kitty, iTerm2, WezTerm

## Key Features

### File Format Conversion
- Opening a `.ipynb` file automatically converts it to markdown representation
- Saving automatically converts back to `.ipynb` format
- Preserves output chunks and metadata

### Code Execution
- Run individual cells with proper output display
- Visual text output appears below code cells
- Images display inline when using supported terminals

### LSP Integration
- Full Python LSP support in code cells (autocomplete, go to definition, etc.)
- Syntax highlighting for both markdown and code cells
- Diagnostics and error checking

## Keybindings

### Basic Molten Commands
**Note**: Uses `<localleader>` (which is space by default)

| Key | Command | Description |
|-----|---------|-------------|
| `<localleader>e` | `:MoltenEvaluateOperator` | Evaluate operator (use with text objects) |
| `<localleader>os` | `:noautocmd MoltenEnterOutput` | Open output window |
| `<localleader>oh` | `:MoltenHideOutput` | Close output window |
| `<localleader>rr` | `:MoltenReevaluateCell` | Re-evaluate current cell |
| `<localleader>r` | `:MoltenEvaluateVisual` | Execute visual selection |
| `<localleader>md` | `:MoltenDelete` | Delete Molten cell |
| `<localleader>mx` | `:MoltenOpenInBrowser` | Open output in browser |

### Quarto Runner Commands
| Key | Command | Description |
|-----|---------|-------------|
| `<localleader>rc` | `runner.run_cell` | Run current cell |
| `<localleader>ra` | `runner.run_above` | Run current cell and all above |
| `<localleader>rA` | `runner.run_all` | Run all cells |
| `<localleader>rl` | `runner.run_line` | Run current line |
| `<localleader>r` | `runner.run_range` | Run visual selection |
| `<localleader>RA` | `runner.run_all(true)` | Run all cells of all languages |

## Usage Workflow

### Opening a Jupyter Notebook
1. Open any `.ipynb` file: `nvim notebook.ipynb`
2. The file is automatically converted to markdown representation
3. Molten automatically initializes with the appropriate kernel
4. Existing outputs are imported and displayed

### Working with Cells
1. Navigate to a code cell (between ````python` and ````)
2. Use `<localleader>rc` to run the current cell
3. Use `<localleader>rA` to run all cells
4. Use visual mode + `<localleader>r` to run selected code

### Creating New Notebooks
```vim
:NewNotebook my_notebook
```
This creates `my_notebook.ipynb` with proper metadata and opens it.

### Saving Work
- `:w` automatically saves the markdown representation
- Output chunks are automatically exported to the `.ipynb` file
- Both source and output are preserved

## Troubleshooting

### Common Issues

1. **"No kernel available" error**:
   - Run `:MoltenAvailableKernels` to see available kernels
   - Ensure Python and ipykernel are installed: `pip install ipykernel`
   - Create a kernel: `python -m ipykernel install --user --name myenv`

2. **Images not displaying**:
   - Ensure you're using a supported terminal (Ghostty, Kitty, etc.)
   - Check that `image.nvim` backend is set correctly for your terminal

3. **LSP not working in code cells**:
   - Ensure `pyright` is installed: `:Mason` and install `pyright`
   - Make sure quarto is activated: should happen automatically in markdown files

4. **Plugin not loading**:
   - Run `:Lazy sync` to ensure all plugins are installed
   - Restart Neovim after installation

### Debugging Commands
```vim
:checkhealth molten
:MoltenInfo
:Lazy
:Mason
```

## Configuration Details

The setup includes:

1. **Molten Configuration**:
   - Auto-open output: disabled (use `<localleader>os` to open manually)
   - Image provider: `image.nvim`
   - Virtual text output: enabled
   - Output wrapping: enabled

2. **Quarto Configuration**:
   - Languages: Python, R, Rust
   - LSP features: completion, diagnostics, hover, etc.
   - Code runner: uses Molten as default

3. **Jupytext Configuration**:
   - Style: markdown
   - Output extension: `.md`
   - Force filetype: markdown

4. **Auto-commands**:
   - Automatic kernel initialization when opening `.ipynb` files
   - Automatic output import/export
   - Filetype-specific Molten settings

## Comparison with VSCode

### Advantages
- Full Vim/Neovim editing capabilities
- Better text manipulation and navigation
- Customizable interface and keybindings
- Integrated terminal and file management
- No electron overhead

### Trade-offs
- More complex initial setup
- Some output formats may not render (complex HTML)
- No visual notebook interface (cells are in markdown format)
- Requires terminal with image support for inline images

## Additional Features

### Text Objects (Optional)
With treesitter text objects, you can:
- `vib` - select inside code block
- `vab` - select around code block  
- `]b` / `[b` - navigate between code blocks

### Command Line Usage
```bash
# Open notebook directly
nvim notebook.ipynb

# Create new notebook
nvim -c ":NewNotebook test"
```

This setup provides a powerful, terminal-based Jupyter notebook experience that rivals traditional notebook interfaces while maintaining all the benefits of Neovim. 