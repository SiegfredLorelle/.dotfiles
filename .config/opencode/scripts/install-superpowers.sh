#!/bin/bash

# Superpowers Installation Script for OpenCode
# This script installs the superpowers plugin for OpenCode
# Repository: https://github.com/obra/superpowers

set -e

SUPERPOWERS_DIR="$HOME/.config/opencode/superpowers"
PLUGINS_DIR="$HOME/.config/opencode/plugins"
SKILLS_DIR="$HOME/.config/opencode/skills"

echo "=== Superpowers Installer for OpenCode ==="
echo

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: Git is required but not installed."
    echo "Install with: sudo pacman -S git"
    exit 1
fi

# Clone or update superpowers
if [ -d "$SUPERPOWERS_DIR/.git" ]; then
    echo "Superpowers directory already exists. Updating..."
    cd "$SUPERPOWERS_DIR"
    git pull
    echo "✓ Superpowers updated successfully"
else
    echo "Cloning superpowers repository..."
    git clone https://github.com/obra/superpowers.git "$SUPERPOWERS_DIR"
    echo "✓ Superpowers cloned successfully"
fi

# Create necessary directories
echo "Creating plugin directories..."
mkdir -p "$PLUGINS_DIR" "$SKILLS_DIR"

# Remove old symlinks if they exist (safe for reinstalls)
if [ -L "$PLUGINS_DIR/superpowers.js" ]; then
    echo "Removing old plugin symlink..."
    rm "$PLUGINS_DIR/superpowers.js"
fi

if [ -L "$SKILLS_DIR/superpowers" ]; then
    echo "Removing old skills symlink..."
    rm "$SKILLS_DIR/superpowers"
fi

# Create symlinks
echo "Creating symlinks..."
ln -s "$SUPERPOWERS_DIR/.opencode/plugins/superpowers.js" "$PLUGINS_DIR/superpowers.js"
ln -s "$SUPERPOWERS_DIR/skills" "$SKILLS_DIR/superpowers"

echo "✓ Symlinks created successfully"
echo

# Verification
echo "=== Verification ==="
echo

echo "Plugin symlink:"
ls -l "$PLUGINS_DIR/superpowers.js"
echo

echo "Skills symlink:"
ls -l "$SKILLS_DIR/superpowers"
echo

# Check if symlinks are valid
if [ ! -e "$PLUGINS_DIR/superpowers.js" ]; then
    echo "⚠ Warning: Plugin symlink appears to be broken"
fi

if [ ! -e "$SKILLS_DIR/superpowers" ]; then
    echo "⚠ Warning: Skills symlink appears to be broken"
fi

echo "=== Installation Complete ==="
echo
echo "Please restart OpenCode to load the superpowers plugin."
echo
echo "Test by asking: 'do you have superpowers?'"
echo
echo "To update superpowers in the future, run:"
echo "  cd ~/.config/opencode/superpowers && git pull"
