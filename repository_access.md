# SSH Remote Access to GitHub Repositories (Multiple Keys Setup)

This guide explains how to generate multiple SSH keys for different GitHub repositories and configure them for remote access using SSH. The best way to gain access to a repository on a remote server in general is to use a deploy key which can be configured for read or read + write access to the repository. GitHub requires that each ssh key be used for at most one deploy key, so it is necessary to create a separate ssh key for each repository that needs to be accessed.

## 1. Generate SSH Keys for Each Repository

To generate separate SSH keys for each repository, use the `ssh-keygen` command and provide a unique name for each key.

Note that ed25519 is better than RSA and should be used unless the target does not support it.

```bash
# Replace "email@example.com" with your actual email
# generate key for repo1
ssh-keygen -t ed25519 -C "email@example.com" -f ~/.ssh/id_ed25519_repo1

# generate key for repo2
ssh-keygen -t ed25519 -C "email@example.com" -f ~/.ssh/id_ed25519_repo2
# ... repeat as needed
```

## 2. Start the SSH Agent and Add Keys
Start the SSH agent if it is not yet running:
```bash
eval "$(ssh-agent -s)"
```
Add newly created keys:
```bash
ssh-add ~/.ssh/id_ed25519_repo1
ssh-add ~/.ssh/id_ed25519_repo2
```

## 3. Configure the `~/.ssh/config` File

To specify which key SSH should use for each repository, create/edit the file `~/.ssh/config` with the following format for each key:

```ini
# First repository
Host github-repo1
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_repo1
    IdentitiesOnly yes

# Second repository
Host github-repo2
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_repo2
    IdentitiesOnly yes
```
Make sure the github-repo1, github-repo2, etc are unique and clear names for the usecase of each key.

Also make sure the IdentityFile points to the correct corresponding private key.

## 4. Add the Public Keys as Deploy Keys on GitHub

1. Copy the public ssh key from a key-pair
```bash
cat ~/.ssh/id_ed25519_repo1.pub
```

2. Go to your repository on GitHub.
3. In Settings > Deploy keys, click Add deploy key.
4. Paste the public key and give it a title.
5. Check Allow write access if necessary.
6. Repeat for the second repository.

## 5. Clone Repositories Using SSH
Use the custom hostnames specified in `~/.ssh/config` as well as the SSH form of the GitHub clone url:
```bash
git clone git@github-repo1:username/repo1.git
git clone git@github-repo2:username/repo2.git
```

(if not working, try testing the connection to github with `ssh -T git@github-repo1`)