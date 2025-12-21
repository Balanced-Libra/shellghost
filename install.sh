#!/usr/bin/env bash
set -euo pipefail

REPO="GhostEnvoy/Shell-Ghost"
BIN_NAME="ghost"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  darwin) OS="darwin" ;;
  linux) OS="linux" ;;
  *)
    echo "Unsupported OS: $OS" >&2
    exit 1
    ;;
esac

case "$ARCH" in
  x86_64|amd64) ARCH="x64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

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

mkdir -p "${INSTALL_DIR}"

TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "${TMP_DIR}"; }
trap cleanup EXIT

ASSET="ghost-in-the-shell-${OS}-${ARCH}.tar.gz"

API_URL="https://api.github.com/repos/${REPO}/releases/latest"

if command -v curl >/dev/null 2>&1; then
  JSON="$(curl -fsSL "${API_URL}")"
elif command -v wget >/dev/null 2>&1; then
  JSON="$(wget -qO- "${API_URL}")"
else
  echo "Need curl or wget" >&2
  exit 1
fi

DOWNLOAD_URL="$(printf '%s' "${JSON}" | tr -d '\n' | sed 's/\\"/"/g' | grep -o "https://github.com/${REPO}/releases/download/[^\"]*${ASSET}" | head -n 1)"

if [ -z "${DOWNLOAD_URL}" ]; then
  echo "Could not find release asset: ${ASSET}" >&2
  echo "Make sure a GitHub Release exists with that asset name." >&2
  exit 1
fi

ARCHIVE_PATH="${TMP_DIR}/${ASSET}"

if command -v curl >/dev/null 2>&1; then
  curl -fL "${DOWNLOAD_URL}" -o "${ARCHIVE_PATH}"
else
  wget -qO "${ARCHIVE_PATH}" "${DOWNLOAD_URL}"
fi

BIN_PATH="${TMP_DIR}/bin/shellghost"
tar -xzf "${ARCHIVE_PATH}" -C "${TMP_DIR}"

if [ ! -f "${BIN_PATH}" ]; then
  echo "Downloaded archive did not contain expected binary 'shellghost'" >&2
  exit 1
fi

chmod +x "${BIN_PATH}"
install -m 755 "${BIN_PATH}" "${INSTALL_DIR}/${BIN_NAME}"

echo "Installed ${BIN_NAME} to ${INSTALL_DIR}/${BIN_NAME}"
echo "If '${INSTALL_DIR}' is not in your PATH, add it (e.g. export PATH=\"${INSTALL_DIR}:\$PATH\")."
