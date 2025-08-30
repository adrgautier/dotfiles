#!/usr/bin/env bash
set -euo pipefail

# install fish
echo -e ">>> Install fish...\n"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo add-apt-repository ppa:fish-shell/release-4 -y && sudo apt update && sudo apt install -y fish
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install fish
fi

# set fish as default shell
if [ -t 0 ]; then
    echo -e ">>> Set fish as default shell...\n"
    # Add fish to /etc/shells if not present
    if ! grep -q "$(command -v fish)" /etc/shells; then
        echo "$(command -v fish)" | sudo tee -a /etc/shells
    fi

    # Change default shell for user
    chsh -s "$(command -v fish)"
else
# skip modifying /etc/shells and chsh in non-interactive environments (like Codespaces)
    echo -e  ">>> Non-interactive environment detected; skipping chsh and /etc/shells modification\n"
fi

# fisher
echo -e ">>> Installing fisher...\n"
mkdir -p ~/.config/fish/functions
curl -fsSLo ~/.config/fish/functions/fisher.fish https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish

# tide (via fisher)
echo -e ">>> Installing tide...\n"
echo "fisher install IlanCosman/tide@v6" | fish

echo -e ">>> Configuring tide...\n"
echo "tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Sparse --icons='Few icons' --transient=Yes" | fish

# fnm
if ! command -v fnm &>/dev/null; then
    echo -e ">>> Installing fnm...\n"
	curl -fsSL https://fnm.vercel.app/install | bash
else
    echo -e ">>> fnm already installed.\n"
fi

# pnpm
if ! command -v pnpm &>/dev/null; then
    echo -e ">>> Installing pnpm...\n"
	curl -fsSL https://get.pnpm.io/install.sh | sh -
else
    echo -e ">>> pnpm already installed.\n"
fi

# override fish config
echo -e ">>> Override fish config...\n"
cp "$PWD/fish/config.fish" ~/.config/fish/config.fish

# override git config
echo -e ">>> Override git config...\n"
cp "$PWD/.gitconfig" ~/.gitconfig

echo ">>> Done"