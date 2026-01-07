<p align="center">
  <a href="https://github.com/Balanced-Libra/shellghost">
    <picture>
      <img src="packages/opencode/src/cli/cmd/tui/component/logo.tsx" alt="ShellGhost logo">
    </picture>
  </a>
</p>
<p align="center">ShellGhost - Transform your computer into an autonomous AI system.</p>
<p align="center">
  <a href="https://github.com/Balanced-Libra/shellghost"><img alt="GitHub stars" src="https://img.shields.io/github/stars/Balanced-Libra/shellghost?style=flat-square" /></a>
  <a href="https://github.com/Balanced-Libra/shellghost/actions"><img alt="Build status" src="https://img.shields.io/github/actions/workflow/status/Balanced-Libra/shellghost/publish.yml?style=flat-square&branch=main" /></a>
</p>

### Our Mission

ShellGhost is designed to turn your computer into a truly autonomous AI system. By installing ShellGhost on a dedicated machine, it gains full control to operate independently—writing its own scripts, managing hardware, and maintaining its own file structures and memory prompts. No more manual configurations for Bluetooth, WiFi, or device connections; just tell the computer what you need, and it handles the rest.

Imagine plugging in a USB stick and instructing ShellGhost to download files, sort them, or transfer data autonomously. Or connecting devices wirelessly without touching settings—the AI writes scripts and manages connections on its own. The possibilities are endless: from hardware automation to intelligent file management.

We've modified the core to enable god mode for maximum autonomy, removing permission prompts so the AI can act decisively. Future plans include integrating local models for enhanced intelligence and offline capabilities.

This is about creating a computer with actual intelligence—a dedicated AI system that remembers its tasks, adapts, and executes without constant oversight.

---

### Prerequisites: Installing Node.js and npm

ShellGhost can be installed via npm, which is included with Node.js. If you don't have Node.js installed, download and install it first. This will also install npm.

**macOS (using Homebrew):**

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then install Node.js
brew install node

# For ShellGhost installation, we recommend using Homebrew:
brew install ghost
```

**Linux (Ubuntu/Debian):**

```bash
# Add NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# Install Node.js (which includes npm)
sudo apt-get install -y nodejs
```

**Windows (using Chocolatey):**

```powershell
choco install nodejs
```

**Windows (manual download):**
Download the latest LTS version from [nodejs.org](https://nodejs.org/), run the installer, and follow the prompts.

After installation, verify Node.js and npm are installed:

```bash
node --version
npm --version
```

### Installation

```bash
# Build from source
git clone https://github.com/Balanced-Libra/shellghost.git
cd shellghost/packages/opencode
bun install
bun run build

# Install prebuilt (macOS/Linux)
curl -fsSL https://raw.githubusercontent.com/Balanced-Libra/shellghost/main/install.sh | bash

# Install prebuilt (Windows PowerShell)
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/Balanced-Libra/shellghost/main/install.ps1 | iex"

# Package managers (community maintained)
# For macOS, we recommend Homebrew for the easiest installation:
brew install ghost              # macOS and Linux
npm i -g ghost-in-the-shell@latest        # or bun/pnpm/yarn
scoop bucket add extras; scoop install extras/ghost  # Windows
choco install ghost             # Windows
paru -S ghost-bin               # Arch Linux
mise use -g ubi:Balanced-Libra/shellghost # Any OS
nix run nixpkgs#ghost           # or github:Balanced-Libra/shellghost for latest dev branch
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
GHOST_INSTALL_DIR=/usr/local/bin curl -fsSL https://raw.githubusercontent.com/Balanced-Libra/shellghost/main/install.sh | bash
XDG_BIN_DIR=$HOME/.local/bin curl -fsSL https://raw.githubusercontent.com/Balanced-Libra/shellghost/main/install.sh | bash
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
  - Ideal for dedicated autonomous systems or trusted environments

Also, included is a **general** subagent for complex searches and multi-step tasks.
This is used internally and can be invoked using `@general` in messages.

Learn more about [agents](https://github.com/Balanced-Libra/shellghost/docs/agents).

> **Note:** For dedicated autonomous systems, we recommend using the **god** agent mode, which allows full access without permission prompts, enabling true AI autonomy.

### Documentation

For more info on how to configure ShellGhost [**head over to our docs**](https://github.com/Balanced-Libra/shellghost/docs).

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
- **Autonomous Mode:** Unlike Claude Code, ShellGhost supports a "god" mode for fully autonomous operation on dedicated systems, where the AI can manage hardware, write scripts, and maintain persistent memory without user prompts.

#### What is the vision for ShellGhost?

ShellGhost aims to create truly intelligent computers. Install it on a dedicated machine, and it becomes an autonomous AI system capable of:

- Writing and executing its own scripts for tasks like device connections or data management
- Managing hardware autonomously (e.g., USB transfers, network configurations)
- Maintaining persistent memory and prompts to remember its identity and ongoing tasks across sessions
- Handling complex workflows without manual intervention

Future plans include local model integration for enhanced offline intelligence. The goal is a computer that "just works" intelligently, adapting to user needs without constant oversight.

---

**Join our community** [GitHub](https://github.com/Balanced-Libra/shellghost) | [Issues](https://github.com/Balanced-Libra/shellghost/issues)
