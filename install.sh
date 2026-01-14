#!/usr/bin/env bash
set -euo pipefail

REPO="GhostEnvoy/Shell-Ghost"
BIN_NAME="ghost"

# Install bun if not present
if ! command -v bun >/dev/null 2>&1; then
  echo "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
  export PATH="$HOME/.bun/bin:$PATH"
fi

INSTALL_DIR="${GHOST_INSTALL_DIR:-${XDG_BIN_DIR:-}}"
if [ -z "${INSTALL_DIR}" ]; then
  if [ -d "${HOME}/.local/bin" ]; then
    INSTALL_DIR="${HOME}/.local/bin"
  elif [ -d "${HOME}/bin" ] || mkdir -p "${HOME}/bin" 2>/dev/null; then
    INSTALL_DIR="${HOME}/bin"
  else
    INSTALL_DIR="${HOME}/.ghost/bin"
    mkdir -p "${INSTALL_DIR}"
  fi
fi

REPO_DIR="${HOME}/shellghost"

if [ -d "${REPO_DIR}" ]; then
  echo "Updating existing installation in ${REPO_DIR}..."
  cd "${REPO_DIR}"
  git pull
else
  echo "Cloning repository to ${REPO_DIR}..."
  git clone "https://github.com/${REPO}.git" "${REPO_DIR}"
  cd "${REPO_DIR}"
fi

echo "Installing dependencies..."
bun install

# Create wrapper script
cat > "${INSTALL_DIR}/${BIN_NAME}" << 'EOF'
#!/usr/bin/env bash
cd "$HOME/shellghost"
exec bun run --cwd packages/opencode --conditions=browser src/index.ts "$@"
EOF

chmod +x "${INSTALL_DIR}/${BIN_NAME}"

echo "Installed ${BIN_NAME} to ${INSTALL_DIR}/${BIN_NAME}"
echo "Repository installed to ${REPO_DIR}"
echo "If '${INSTALL_DIR}' is not in your PATH, add it (e.g. export PATH=\"${INSTALL_DIR}:\$PATH\")."
echo "You can now run 'ghost' to start ShellGhost."
