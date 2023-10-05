echo "basic_stuff: installs vim, git and other compilation tools"
function basic_stuff(){
	sudo apt install build-essential \
		vim tmux -y
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
	sudo add-apt-repository ppa:neovim-ppa/unstable
	sudo apt update
	sudo apt install neovim -y
}

echo "install_ssh: installs and configures ssh"
function install_ssh(){
	sudo apt install openssh-server openssh-client -y
}
