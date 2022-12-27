# Dotfiles

- Update your OS _(optional)_.

Ubuntu:

```sh
sudo apt update -y
sudo apt upgrade -y
sudo sed -i 's/Prompt=lts/Prompt=normal/g' /etc/update-manager/release-upgrades
sudo do-release-upgrade --allow-third-party
```

- Create a
  [Personal Access Token in your GitHub account](https://github.com/settings/tokens/new).
  If you can't access this link, try the
  [instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

- In your `$HOME` directory, do the following. This clones the `.ssh` folder,
  fixes its permissions (`chmod`) and clones `dotfiles`.

```sh
cd ~

git clone https://github.com/satvikpendem/.ssh.git

sudo chmod 600 ~/.ssh/id_ed25519
sudo chmod 600 ~/.ssh/id_ed25519.pub
sudo chmod 644 ~/.ssh/known_hosts
sudo chmod 755 ~/.ssh

git clone --recurse-submodules -j8 git@github.com:satvikpendem/dotfiles.git
```

- Run the `install.sh` script.

```sh
sh ~/dotfiles/install.sh
```
