# Dotfiles

1. Create a [Person Access Token in your GitHub account](https://github.com/settings/tokens/new). If you can't access this link, try the [instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).

2. In your `$HOME` directory, do the following. This clones the `.ssh` folder, fixes its permissions (`chmod`) and clones `dotfiles`.

```sh
git clone https://github.com/satvikpendem/.ssh.git

sudo chmod 600 ~/.ssh/id_ed25519
sudo chmod 600 ~/.ssh/id_ed25519.pub
sudo chmod 644 ~/.ssh/known_hosts
sudo chmod 755 ~/.ssh

git clone --recurse-submodules -j8 git@github.com:satvikpendem/dotfiles.git
```