echo "install_mint_development_environment: basically runs all the commands within this source file"
echo ""

function install_mint_development_environment() {
	basic_stuff
	zsh_plus
	github
	bleeding_edge_neovim
	nvim_stuff
	latex_stuff
	terminal_navigation
	install_ssh
	rust_install
	rust_stuff 
	alacritty_setup
	apt_fast_install
	kde_stuff
	latest_gcc
	citations
	rust_eframe_deps
}

echo "basic_stuff: installs vim, git and other compilation tools"
function basic_stuff(){
	sudo apt install build-essential \
		vim tmux cmake fontconfig gcc gfortran -y

	rm ~/.tmux.conf
	cp tmux.conf ~/.tmux.conf

	}

echo "zsh_plus: zsh and font installs"
function zsh_plus(){
	sudo apt install zsh-dev zsh-autosuggestions zsh-syntax-highlighting -y

	mkdir -p ~/.fonts
	curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf --output ~/.fonts/'MesloLGS NF Regular.ttf'
	curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf --output ~/.fonts/'MesloLGS NF Bold.ttf'
	curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf --output ~/.fonts/'MesloLGS NF Italic.ttf'
	curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf --output ~/.fonts/'MesloLGS NF Bold Italic.ttf'

	rm -rf ~/powerlevel10k
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

	zsh -c 'source ~/.zshrc && p10k configure'

	echo "alias ls=exa" >> ~/.p10k.zsh
	echo "alias l='exa -al'" >> ~/.p10k.zsh
	echo "export TERM=screen-256color" >> ~/.p10k.zsh
}




echo "github: installs github cli"
function github(){
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

}

echo "bleeding_edge_neovim : installs ppas and neovim bleeding edge"
function bleeding_edge_neovim(){
	sudo add-apt-repository ppa:neovim-ppa/unstable -y
	sudo apt update
	sudo apt install neovim -y
}

echo "install_ssh: installs and configures ssh"
function install_ssh(){
	sudo apt install openssh-server openssh-client -y
}

echo "rust_install: installs rust and rustup"
function rust_install(){
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source ~/.bashrc
}

echo "rust_stuff: installs rust tools using cargo and such"
function rust_stuff(){
	sudo apt install exa -y
	cargo install bat cargo-watch flamegraph ripgrep

	rustup override set stable
	rustup update stable
	sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y
	git clone https://github.com/alacritty/alacritty.git
	cd alacritty
	cargo build --release
	infocmp alacritty
	sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
	sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
	sudo desktop-file-install extra/linux/Alacritty.desktop
	sudo update-desktop-database


	sudo apt install scdoc -y
	sudo mkdir -p /usr/local/share/man/man1
	sudo mkdir -p /usr/local/share/man/man5
	scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
	scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
	scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
	scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
	mkdir -p ~/.bash_completion
	cp extra/completions/alacritty.bash ~/.bash_completion/alacritty

	cd ..

	echo "source ~/.bash_completion/alacritty" >> ~/.bashrc
}

echo "alacritty_setup: sets up alacritty along with its fonts"
function alacritty_setup(){
	rm -rf ~/.alacritty.yml ~/.alacritty.toml
	cp alacritty.toml ~/.alacritty.toml
}


echo "terminal_navigation: tools for convenient terminal navigation"
function terminal_navigation(){
	sudo apt install fzf -y
}

echo "apt_fast_install: installs apt fast"
function apt_fast_install(){
	sudo apt install aria2 -y
	/bin/bash -c "$(curl -sL https://git.io/vokNn)"
}

echo "latex_stuff: installs most essential things for latex"
function latex_stuff(){
	sudo apt install texlive-full -y
}

echo "nvim_stuff: configures nvim to some level of capability"
function nvim_stuff(){
	mkdir ~/.config/nvim
	cp nvim_files/basic_init.lua ~/.config/nvim/init.lua

	sudo apt install vim-gitgutter -y
	sudo apt install vim-airline vim-airline-themes vim-ale -y
	sudo apt install vim-solarized vim-snippets -y
	sudo apt install vim-latexsuite vim-tabular -y
	sudo apt install vim-ctrlp universal-ctags -y
	sudo apt install npm python3-pynvim -y

	# packer
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
		~/.local/share/nvim/site/pack/packer/start/packer.nvim

	# lua plugins
	mkdir -p ~/.config/nvim/lua/
	rm ~/.config/nvim/lua/plugins.lua
	cp nvim_files/init.lua ~/.config/nvim/init.lua
	cp nvim_files/plugins.lua ~/.config/nvim/lua/plugins.lua

	#lua basic settings
	mkdir -p ~/.config/nvim/lua/basic_settings
	rm ~/.config/nvim/lua/basic_settings/settings.lua
	cp nvim_files/basic_init.lua ~/.config/nvim/lua/basic_settings/settings.lua

	# lua lsp 
	rm ~/.config/nvim/lua/lsp.lua
	cp nvim_files/lsp.lua ~/.config/nvim/lua/lsp.lua

	# lua telescope and harpoon 
	rm ~/.config/nvim/lua/telescope_harpoon.lua
	cp nvim_files/telescope_harpoon.lua ~/.config/nvim/lua/telescope_harpoon.lua

	# hop 
	rm ~/.config/nvim/lua/hop_settings.lua
	cp nvim_files/hop_settings.lua ~/.config/nvim/lua/hop_settings.lua

}

echo "kde_stuff: installs useful software from kde suite"
function kde_stuff(){
	sudo apt install okular-dev okular -y
}

echo "latest_gcc: installs latest version of gcc for newer processors"
function latest_gcc(){
	sudo add-apt-repository ppa:ubuntu-toolchain-r/ppa -y
	sudo apt update
	sudo apt install g++-12 gcc-12 -y
}

echo "citations: installs jabref and other suites"
function citations(){
	sudo apt install jabref -y
}

echo "rust_eframe_deps: installs rust-eframe dependencies"
function rust_eframe_deps(){
	sudo apt-get install libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libxkbcommon-dev libssl-dev -y
}

echo "tuxedo_firmware_jammy: 
for clevo laptops specificially, install firmware for keyboard, fan etc
	only works for jammy ubuntu"
function tuxedo_firmware_jammy(){
	sudo add-apt-repository "deb https://deb.tuxedocomputers.com/ubuntu jammy main"
	sudo apt update --allow-insecure-repositories
	sudo apt install --allow-unauthenticated tuxedo-archive-keyring -y
	sudo apt update
	sudo apt install tuxedo-control-center tuxedo-keyboard -y
}

echo "samba_install: installs and configures samba"
function samba_install(){
	sudo apt install samba -y
	mkdir /home/$USER/Public/sambaSharedFolder
	# note, the double quotes will allow input from bash variables 
	# eg. $USER
	cp ./smb-template.conf ./smb.conf
	sed -i "s/input_user/$USER/g" ./smb.conf
	sudo cp -i ./smb.conf /etc/samba/.
	# add user to smb 
	sudo smbpasswd -a $USER
	sudo systemctl enable smbd 
	sudo systemctl restart smbd

}

echo "wsdd_install: installs wsdd for samba"
function wsdd_install(){
	sudo apt install wsdd2 -y
	sudo systemctl enable wsdd2
	sudo systemctl start wsdd2
}
