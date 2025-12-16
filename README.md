<p align="center">
  <a href="https://github.com/Balanced-Libra/GhostShell">
    <picture>
      <img src="GHOSTSHELL.md" alt="GhostShell logo">
    </picture>
  </a>
</p>
<p align="center">GhostShell - The open source AI coding agent.</p>
<p align="center">
  <a href="https://github.com/Balanced-Libra/GhostShell"><img alt="GitHub stars" src="https://img.shields.io/github/stars/Balanced-Libra/GhostShell?style=flat-square" /></a>
  <a href="https://github.com/Balanced-Libra/GhostShell/actions"><img alt="Build status" src="https://img.shields.io/github/actions/workflow/status/Balanced-Libra/GhostShell/publish.yml?style=flat-square&branch=main" /></a>
</p>


---

### Installation

```bash
# Build from source
git clone https://github.com/Balanced-Libra/GhostShell.git
cd GhostShell/packages/opencode
bun install
bun run build

# Package managers (community maintained)
npm i -g ghost-in-the-shell@latest        # or bun/pnpm/yarn
scoop bucket add extras; scoop install extras/ghost  # Windows
choco install ghost             # Windows
brew install ghost              # macOS and Linux
paru -S ghost-bin               # Arch Linux
mise use -g ubi:Balanced-Libra/GhostShell # Any OS
nix run nixpkgs#ghost           # or github:Balanced-Libra/GhostShell for latest dev branch
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
GHOST_INSTALL_DIR=/usr/local/bin curl -fsSL https://ghostshell.ai/install | bash
XDG_BIN_DIR=$HOME/.local/bin curl -fsSL https://ghostshell.ai/install | bash
```

### Agents

GhostShell includes three built-in agents you can switch between,
you can switch between these using the `Tab` key.

- **build** - Default, full access agent for development work
- **plan** - Read-only agent for analysis and code exploration
  - Denies file edits by default
  - Asks permission before running bash commands
  - Ideal for exploring unfamiliar codebases or planning changes
- **god** - Full access agent with no permission prompts
  - Automatically allows all file edits
  - Automatically allows all bash commands
  - Ideal for trusted environments or rapid prototyping

Also, included is a **general** subagent for complex searches and multi-step tasks.
This is used internally and can be invoked using `@general` in messages.

Learn more about [agents](https://github.com/Balanced-Libra/GhostShell/docs/agents).

### Documentation

For more info on how to configure GhostShell [**head over to our docs**](https://github.com/Balanced-Libra/GhostShell/docs).

### Contributing

If you're interested in contributing to GhostShell, please read our [contributing docs](./CONTRIBUTING.md) before submitting a pull request.

### Building on GhostShell

If you are working on a project that's related to GhostShell and is using "ghost" as a part of its name; for example, "ghost-dashboard" or "ghost-mobile", please add a note to your README to clarify that it is not built by the GhostShell team and is not affiliated with us in anyway.

### FAQ

#### How is this different than Claude Code?

It's very similar to Claude Code in terms of capability. Here are the key differences:

- 100% open source
- Not coupled to any provider. GhostShell can be used with Claude, OpenAI, Google or even local models. As models evolve the gaps between them will close and pricing will drop so being provider-agnostic is important.
- Out of the box LSP support
- A focus on TUI. GhostShell is built by terminal power users; we are going to push the limits of what's possible in the terminal.
- A client/server architecture. This for example can allow GhostShell to run on your computer, while you can drive it remotely from a mobile app. Meaning that the TUI frontend is just one of the possible clients.


---

**Join our community** [GitHub](https://github.com/Balanced-Libra/GhostShell) | [Issues](https://github.com/Balanced-Libra/GhostShell/issues)
