#!/usr/bin/env bash
set -euo pipefail

# Optional: override version/tag or repo
VERSION="${VERSION:-latest}"
REPO_OVERRIDE="${REPO_OVERRIDE:-}"
REPO_CANDIDATES=(
  "GhostEnvoy/Shell-Ghost"
  "Balanced-Libra/Shell-Ghost"
  "Balanced-Libra/GhostShell"
)

if [[ -n "$REPO_OVERRIDE" ]]; then
  REPO_CANDIDATES=("$REPO_OVERRIDE" "${REPO_CANDIDATES[@]}")
fi

detect_platform() {
  local os arch
  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  arch=$(uname -m)
  case "$arch" in
    x86_64|amd64) arch="x64" ;;
    arm64|aarch64) arch="arm64" ;;
    *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
  esac
  echo "${os}-${arch}"
}

resolve_repo() {
  local repo tag
  for c in "${REPO_CANDIDATES[@]}"; do
    if [[ "$VERSION" == "latest" ]]; then
      tag=$(curl -fsSL "https://api.github.com/repos/${c}/releases/latest" | jq -r '.tag_name' 2>/dev/null || true)
    else
      tag="$VERSION"
    fi
    if [[ -n "$tag" && "$tag" != "null" ]]; then
      echo "${c}|${tag}"
      return 0
    fi
  done
  echo "Could not find a reachable repo from: ${REPO_CANDIDATES[*]}" >&2
  exit 1
}

target="$(detect_platform)"
resolved="$(resolve_repo)"
REPO="${resolved%%|*}"
TAG="${resolved##*|}"

asset_bases=(
  "ghost-in-the-shell-${target}"
  "ghost-${target}"
  "shellghost-${target}"
)
asset_suffixes=("" "-baseline" "-musl")

BASE_DIR="${HOME}/.ghost"
BIN_DIR="${BASE_DIR}/bin"
mkdir -p "${BIN_DIR}"

found_asset=""
for base in "${asset_bases[@]}"; do
  for suffix in "${asset_suffixes[@]}"; do
    asset="${base}${suffix}.tar.gz"
    url="https://github.com/${REPO}/releases/download/${TAG}/${asset}"
    if curl -fsI "$url" >/dev/null 2>&1; then
      found_asset="$asset"
      break 2
    fi
  done
done

if [[ -z "$found_asset" ]]; then
  echo "No compatible asset found for ${target} in ${REPO}@${TAG}" >&2
  exit 1
fi

echo "Downloading ${found_asset} from ${REPO}@${TAG}..."
curl -fL "https://github.com/${REPO}/releases/download/${TAG}/${found_asset}" -o "${BIN_DIR}/ghost.tar.gz"

tar -xzf "${BIN_DIR}/ghost.tar.gz" -C "${BIN_DIR}"
rm -f "${BIN_DIR}/ghost.tar.gz"

# Find binary (shellghost or ghost) and place on PATH
exe_path="$(find "${BIN_DIR}" -maxdepth 3 -type f \( -name 'ghost' -o -name 'ghost.exe' -o -name 'shellghost' \) | head -n 1)"
if [[ -z "$exe_path" ]]; then
  echo "Could not find extracted binary in ${BIN_DIR}" >&2
  exit 1
fi

chmod +x "$exe_path"
ln -sf "$exe_path" "${BIN_DIR}/ghost"

case ":$PATH:" in
  *":${BIN_DIR}:"*) echo "Install complete. Binary: ${exe_path}" ;;
  *) echo "Install complete. Add ${BIN_DIR} to your PATH." ;;
esac
