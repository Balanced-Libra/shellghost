# Deploying to GitHub and publishing releases

## Push the repository
- `git remote add origin https://github.com/Balanced-Libra/Shell-Ghost.git`
- `git push -u origin main` (or your current branch)

## Tag and publish a release
- `git tag v1.0.0`
- `git push origin v1.0.0`
- GitHub Actions will build per-OS artifacts and attach them to the release.

## Install commands to share
- macOS/Linux: `curl -fsSL https://raw.githubusercontent.com/Balanced-Libra/Shell-Ghost/main/installer/install-ghost.sh | bash`
- Windows (PowerShell): `iwr -useb https://raw.githubusercontent.com/Balanced-Libra/Shell-Ghost/main/installer/install-ghost.ps1 | iex`

## Check the release
- Open the GitHub Releases page for the tag and verify the uploaded binaries.
