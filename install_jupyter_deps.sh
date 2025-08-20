#!/bin/bash

# Jupyter Notebook Dependencies Installation Script for Neovim
# This script installs all necessary dependencies for the Jupyter notebook setup

set -e

echo "🚀 Installing Jupyter Notebook dependencies for Neovim..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Python packages
install_python_packages() {
    echo "📦 Installing Python packages..."
    
    # Check if pip exists
    if ! command_exists pip && ! command_exists pip3; then
        echo "❌ pip not found. Please install Python and pip first."
        exit 1
    fi
    
    # Use pip3 if available, otherwise pip
    PIP_CMD="pip"
    if command_exists pip3; then
        PIP_CMD="pip3"
    fi
    
    echo "Using $PIP_CMD to install packages..."
    
    # Core Jupyter packages
    $PIP_CMD install --user jupyter ipykernel
    
    # Enhanced functionality packages
    $PIP_CMD install --user jupytext pynvim
    
    # Optional packages for better experience
    $PIP_CMD install --user pillow matplotlib seaborn plotly
    
    echo "✅ Python packages installed successfully!"
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

# Function to install system dependencies on Linux
install_linux_deps() {
    echo "🐧 Installing Linux dependencies..."
    
    # Detect package manager
    if command_exists apt-get; then
        echo "Using apt-get..."
        sudo apt-get update
        sudo apt-get install -y imagemagick
    elif command_exists yum; then
        echo "Using yum..."
        sudo yum install -y ImageMagick
    elif command_exists pacman; then
        echo "Using pacman..."
        sudo pacman -S imagemagick
    else
        echo "❌ Could not detect package manager. Please install ImageMagick manually."
        exit 1
    fi
    
    echo "✅ Linux dependencies installed successfully!"
}

# Function to setup Jupyter kernel
setup_jupyter_kernel() {
    echo "⚙️  Setting up Jupyter kernel..."
    
    # Install Python kernel for current user
    python -m ipykernel install --user --name python3 --display-name "Python 3"
    
    echo "✅ Jupyter kernel setup complete!"
}

# Function to verify installation
verify_installation() {
    echo "🔍 Verifying installation..."
    
    # Check Python packages
    echo "Checking Python packages..."
    python -c "import jupyter, jupytext, pynvim; print('✅ All Python packages available')" || {
        echo "❌ Some Python packages are missing"
        exit 1
    }
    
    # Check Jupyter kernels
    echo "Checking Jupyter kernels..."
    if command_exists jupyter; then
        jupyter kernelspec list
    fi
    
    echo "✅ Installation verification complete!"
}

# Main installation process
main() {
    echo "Starting Jupyter Notebook setup for Neovim..."
    echo "This will install the following dependencies:"
    echo "  - Python: jupyter, ipykernel, jupytext, pynvim, pillow"
    echo "  - System: ImageMagick"
    echo "  - Optional: WezTerm (macOS only)"
    echo
    
    read -p "Continue with installation? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    
    # Install Python packages
    install_python_packages
    
    # Install system dependencies based on OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        install_macos_deps
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        install_linux_deps
    else
        echo "⚠️  Unknown OS type. Skipping system dependency installation."
        echo "   Please install ImageMagick manually for image support."
    fi
    
    # Setup Jupyter kernel
    setup_jupyter_kernel
    
    # Verify installation
    verify_installation
    
    echo
    echo "🎉 Installation complete!"
    echo
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