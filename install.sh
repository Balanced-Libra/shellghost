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

ASSET_BASES=("ghost-in-the-shell-${OS}-${ARCH}" "ghost-${OS}-${ARCH}" "shellghost-${OS}-${ARCH}")
ASSET_SUFFIXES=("" "-baseline" "-musl")

API_URL="https://api.github.com/repos/${REPO}/releases/latest"

if command -v curl >/dev/null 2>&1; then
  JSON="$(curl -fsSL "${API_URL}")"
elif command -v wget >/dev/null 2>&1; then
  JSON="$(wget -qO- "${API_URL}")"
else
  echo "Need curl or wget" >&2
  exit 1
fi

ASSET=""
DOWNLOAD_URL=""
for base in "${ASSET_BASES[@]}"; do
  for suffix in "${ASSET_SUFFIXES[@]}"; do
    candidate="${base}${suffix}.tar.gz"
    url="$(printf '%s' "${JSON}" | tr -d '\n' | sed 's/\\"/"/g' | grep -o "https://github.com/${REPO}/releases/download/[^\"]*${candidate}" | head -n 1)"
    if [ -n "${url}" ]; then
      ASSET="${candidate}"
      DOWNLOAD_URL="${url}"
      break 2
    fi
  done
done

if [ -z "${DOWNLOAD_URL}" ]; then
  echo "Could not find a compatible asset for ${OS}/${ARCH} in ${REPO}." >&2
  echo "Looked for bases: ${ASSET_BASES[*]} with suffixes: ${ASSET_SUFFIXES[*]}" >&2
  exit 1
fi

ARCHIVE_PATH="${TMP_DIR}/${ASSET}"

if command -v curl >/dev/null 2>&1; then
  curl -fL "${DOWNLOAD_URL}" -o "${ARCHIVE_PATH}"
else
  wget -qO "${ARCHIVE_PATH}" "${DOWNLOAD_URL}"
fi

tar -xzf "${ARCHIVE_PATH}" -C "${TMP_DIR}"

BIN_PATH="$(find "${TMP_DIR}" -maxdepth 3 -type f \( -name 'ghost' -o -name 'ghost.exe' -o -name 'shellghost' \) | head -n 1)"

if [ ! -f "${BIN_PATH}" ]; then
  echo "Downloaded archive did not contain expected binary (ghost/shellghost)" >&2
  exit 1
fi

chmod +x "${BIN_PATH}"
install -m 755 "${BIN_PATH}" "${INSTALL_DIR}/${BIN_NAME}"

echo "Installed ${BIN_NAME} to ${INSTALL_DIR}/${BIN_NAME}"
echo "If '${INSTALL_DIR}' is not in your PATH, add it (e.g. export PATH=\"${INSTALL_DIR}:\$PATH\")."
