#!/bin/bash

# Jupyter Notebook Dependencies Installation Script for Neovim (Homebrew Python)
# This script handles the externally-managed-environment issue with Homebrew Python

set -e

echo "🚀 Installing Jupyter Notebook dependencies for Neovim (Homebrew Python)..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Python packages using pipx (recommended approach)
install_with_pipx() {
    echo "📦 Installing Python packages using pipx (recommended)..."
    
    # Install pipx if not already installed
    if ! command_exists pipx; then
        echo "Installing pipx..."
        brew install pipx
        pipx ensurepath
        # Source the updated PATH
        export PATH="$PATH:$HOME/.local/bin"
    fi
    
    echo "Installing Jupyter and related packages with pipx..."
    
    # Install individual Jupyter components that are actual applications
    pipx install jupyterlab  # This includes jupyter-lab, jupyter-labextension, etc.
    pipx inject jupyterlab ipykernel jupytext notebook
    
    # Install pynvim separately
    pipx install pynvim
    
    # For packages that are libraries (not applications), we'll create a venv
    echo "Creating a virtual environment for additional packages..."
    python3 -m venv ~/.nvim-jupyter-env
    source ~/.nvim-jupyter-env/bin/activate
    pip install pillow matplotlib seaborn plotly pandas numpy
    deactivate
    
    echo "✅ Python packages installed successfully with pipx!"
}

# Function to install using the simple Homebrew approach
install_homebrew_simple() {
    echo "📦 Installing Python packages using pip with --break-system-packages..."
    echo "⚠️  This is safe for development tools like Jupyter"
    
    # Use pip with --break-system-packages flag
    echo "Installing core packages..."
    pip3 install --break-system-packages --user jupyter jupyterlab ipykernel
    pip3 install --break-system-packages --user jupytext pynvim
    pip3 install --break-system-packages --user pillow matplotlib seaborn plotly pandas numpy
    
    # Setup Jupyter kernel
    python3 -m ipykernel install --user --name python3 --display-name "Python 3"
    
    echo "✅ Python packages installed successfully!"
}

# Function to install using virtual environment (alternative approach)
install_with_venv() {
    echo "📦 Installing Python packages using virtual environment..."
    
    VENV_PATH="$HOME/.nvim-jupyter-venv"
    
    # Create virtual environment
    echo "Creating virtual environment at $VENV_PATH..."
    python3 -m venv "$VENV_PATH"
    
    # Activate virtual environment
    source "$VENV_PATH/bin/activate"
    
    # Upgrade pip
    pip install --upgrade pip
    
    # Install all packages
    echo "Installing packages in virtual environment..."
    pip install jupyter ipykernel jupytext pynvim
    pip install pillow matplotlib seaborn plotly pandas numpy
    
    # Setup Jupyter kernel for this environment
    python -m ipykernel install --user --name nvim-jupyter --display-name "Neovim Jupyter"
    
    deactivate
    
    echo "✅ Virtual environment created at $VENV_PATH"
    echo "📝 To activate this environment later, run:"
    echo "   source $VENV_PATH/bin/activate"
}

# Function to install system dependencies on macOS
install_macos_deps() {
    echo "🍎 Installing macOS dependencies..."
    
    if ! command_exists brew; then
        echo "❌ Homebrew not found. Please install Homebrew first:"
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    
    # Install ImageMagick for image support
    echo "Installing ImageMagick..."
    brew install imagemagick
    
    # Optional: Install WezTerm for better image support
    read -p "📺 Do you want to install WezTerm for better image support? (y/N): " install_wezterm
    if [[ $install_wezterm =~ ^[Yy]$ ]]; then
        brew install --cask wezterm
        echo "✅ WezTerm installed!"
    fi
    
    echo "✅ macOS dependencies installed successfully!"
}

# Function to setup environment activation helper
create_activation_helper() {
    cat > ~/.config/nvim/activate_jupyter.sh << 'EOF'
#!/bin/bash
# Helper script to activate the Jupyter environment for Neovim

VENV_PATH="$HOME/.nvim-jupyter-venv"

if [ -d "$VENV_PATH" ]; then
    echo "🐍 Activating Jupyter environment for Neovim..."
    source "$VENV_PATH/bin/activate"
    echo "✅ Environment activated! Python packages are now available."
    echo "💡 Run 'deactivate' when you're done."
else
    echo "❌ Virtual environment not found at $VENV_PATH"
    echo "   Please run the installation script again."
    exit 1
fi
EOF
    chmod +x ~/.config/nvim/activate_jupyter.sh
    echo "📁 Created activation helper at ~/.config/nvim/activate_jupyter.sh"
}

# Function to verify installation
verify_installation() {
    echo "🔍 Verifying installation..."
    
    # Check if jupyter is available
    if command_exists jupyter; then
        echo "✅ Jupyter command available globally"
        jupyter --version
    elif [ -d "$HOME/.nvim-jupyter-venv" ]; then
        echo "✅ Jupyter available in virtual environment"
        source "$HOME/.nvim-jupyter-venv/bin/activate"
        jupyter --version
        deactivate
    else
        echo "❌ Jupyter not found"
        return 1
    fi
    
    # Check kernels
    echo "Available Jupyter kernels:"
    if command_exists jupyter; then
        jupyter kernelspec list
    fi
    
    echo "✅ Installation verification complete!"
}

# Main installation process
main() {
    echo "Jupyter Notebook setup for Neovim (Homebrew Python)"
    echo "This script handles the externally-managed-environment issue."
    echo
    echo "Choose installation method:"
    echo "1. pipx - Installs apps globally, libraries in isolated env"
    echo "2. Virtual environment - Everything in one isolated environment"
    echo "3. Simple Homebrew fix (recommended) - Just use --break-system-packages for dev tools"
    echo
    
    read -p "Select option (1/2/3): " choice
    
    case $choice in
        1)
            echo "Using pipx method..."
            install_with_pipx
            ;;
        2)
            echo "Using virtual environment method..."
            install_with_venv
            create_activation_helper
            ;;
        3)
            echo "Using simple Homebrew fix..."
            install_homebrew_simple
            ;;
        *)
            echo "Invalid choice. Using simple Homebrew fix (recommended)..."
            install_homebrew_simple
            ;;
    esac
    
    # Install system dependencies
    install_macos_deps
    
    # Verify installation
    verify_installation
    
    echo
    echo "🎉 Installation complete!"
    echo
    
    if [[ $choice == "2" ]]; then
        echo "📝 Important: Since you used a virtual environment:"
        echo "   - Run 'source ~/.config/nvim/activate_jupyter.sh' before using Neovim for Jupyter"
        echo "   - Or manually activate: source ~/.nvim-jupyter-venv/bin/activate"
        echo "   - Your venv-selector plugin can help manage this automatically"
        echo
    fi
    
    echo "Next steps:"
    echo "1. Restart Neovim"
    echo "2. Run ':Lazy sync' to install the Neovim plugins"
    echo "3. Open a Python file or .ipynb file"
    echo "4. Press <leader>mi to initialize Molten"
    echo "5. Start coding in Jupyter-style cells!"
    echo
    echo "📖 Read JUPYTER_SETUP.md for detailed usage instructions."
}

# Run main function
main "$@" 