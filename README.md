<p align="center">
  <a href="https://github.com/GhostEnvoy/Shell-Ghost">
    <picture>
      <img src="packages/opencode/src/cli/cmd/tui/component/logo.tsx" alt="ShellGhost logo">
    </picture>
  </a>
</p>
<p align="center">ShellGhost - The open source AI coding agent.</p>
<p align="center">
  <a href="https://github.com/GhostEnvoy/Shell-Ghost"><img alt="GitHub stars" src="https://img.shields.io/github/stars/GhostEnvoy/Shell-Ghost?style=flat-square" /></a>
  <a href="https://github.com/GhostEnvoy/Shell-Ghost/actions"><img alt="Build status" src="https://img.shields.io/github/actions/workflow/status/GhostEnvoy/Shell-Ghost/publish.yml?style=flat-square&branch=main" /></a>
</p>


---

### Installation

```bash
# Build from source
git clone https://github.com/GhostEnvoy/Shell-Ghost.git
cd Shell-Ghost/packages/opencode
bun install
bun run build

# Install prebuilt (macOS/Linux)
curl -fsSL https://raw.githubusercontent.com/GhostEnvoy/Shell-Ghost/main/install.sh | bash

# Install prebuilt (Windows PowerShell)
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/GhostEnvoy/Shell-Ghost/main/install.ps1 | iex"

# Package managers (community maintained)
npm i -g ghost-in-the-shell@latest        # or bun/pnpm/yarn
scoop bucket add extras; scoop install extras/ghost  # Windows
choco install ghost             # Windows
brew install ghost              # macOS and Linux
paru -S ghost-bin               # Arch Linux
mise use -g ubi:GhostEnvoy/GhostShell # Any OS
nix run nixpkgs#ghost           # or github:GhostEnvoy/GhostShell for latest dev branch
```

> [!TIP]
> Remove versions older than 0.1.x before installing.

#### Installation Directory

The install script respects the following priority order for the installation path:

1. `$GHOST_INSTALL_DIR` - Custom installation directory
2. `$XDG_BIN_DIR` - XDG Base Directory Specification compliant path
3. `$HOME/bin` - Standard user binary directory (if exists or can be created)
4. `$HOME/.ghost/bin` - Default fallback

```bash
# Examples
GHOST_INSTALL_DIR=/usr/local/bin curl -fsSL https://raw.githubusercontent.com/GhostEnvoy/Shell-Ghost/main/install.sh | bash
XDG_BIN_DIR=$HOME/.local/bin curl -fsSL https://raw.githubusercontent.com/GhostEnvoy/Shell-Ghost/main/install.sh | bash
```

### Agents

ShellGhost includes three built-in agents you can switch between,
you can switch between these using the `Tab` key.

- **build** - Default, full access agent for development work
- **ask** - Read-only agent for analysis and code exploration
  - Denies file edits by default
  - Asks permission before running bash commands
  - Ideal for exploring unfamiliar codebases or planning changes
- **god** - Full access agent with no permission prompts
  - Automatically allows all file edits
  - Automatically allows all bash commands
  - Ideal for trusted environments or rapid prototyping

Also, included is a **general** subagent for complex searches and multi-step tasks.
This is used internally and can be invoked using `@general` in messages.

Learn more about [agents](https://github.com/GhostEnvoy/Shell-Ghost/docs/agents).

### Documentation

For more info on how to configure ShellGhost [**head over to our docs**](https://github.com/GhostEnvoy/Shell-Ghost/docs).

### Contributing

If you're interested in contributing to ShellGhost, please read our [contributing docs](./CONTRIBUTING.md) before submitting a pull request.

### Building on ShellGhost

If you are working on a project that's related to ShellGhost and is using "ghost" as a part of its name; for example, "ghost-dashboard" or "ghost-mobile", please add a note to your README to clarify that it is not built by the ShellGhost team and is not affiliated with us in anyway.

### FAQ

#### How is this different than Claude Code?

It's very similar to Claude Code in terms of capability. Here are the key differences:

- 100% open source
- Not coupled to any provider. ShellGhost can be used with Claude, OpenAI, Google or even local models. As models evolve the gaps between them will close and pricing will drop so being provider-agnostic is important.
- Out of the box LSP support
- A focus on TUI. ShellGhost is built by terminal power users; we are going to push the limits of what's possible in the terminal.
- A client/server architecture. This for example can allow ShellGhost to run on your computer, while you can drive it remotely from a mobile app. Meaning that the TUI frontend is just one of the possible clients.


---

**Join our community** [GitHub](https://github.com/GhostEnvoy/Shell-Ghost) | [Issues](https://github.com/GhostEnvoy/Shell-Ghost/issues)
