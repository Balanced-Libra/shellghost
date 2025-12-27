# ShellGhost - Build Instructions

## Quick Setup
1. Install Bun: `curl -fsSL https://bun.sh/install | bash`
2. Install dependencies: `bun install`
3. Build: `cd packages/opencode && bun run build --target windows-x64`
4. Binary will be in: `packages/opencode/dist/ghost-in-the-shell-windows-x64/bin/shellghost.exe`

## Build for all platforms
`cd packages/opencode && bun run build`

## Available packages
- `packages/opencode` - Main CLI tool
- `packages/*` - Various internal packages

## Main entry point
`packages/opencode/src/index.ts`