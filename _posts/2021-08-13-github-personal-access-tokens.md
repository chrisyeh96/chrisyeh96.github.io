---
title: GitHub Personal Access Tokens
layout: post
use_code: true
last_updated: 2021-08-13
tags: [git]
excerpt: In [July 2020](https://github.blog/2020-07-30-token-authentication-requirements-for-api-and-git-operations/), GitHub announced that in "Mid-2021 - Personal access or OAuth tokens will be required for all authenticated Git operations." In [December 2020](https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/), GitHub set that date for August 13, 2021--i.e., today. Effectively, GitHub users can no longer access their existing GitHub repos with their username and password using the git command line. Instead, users must use either SSH or a personal access token. This post describes how to set up personal access tokens and use them with Git.
---


## Personal Access Tokens

**Create a Personal Access Token**

1. Log into GitHub online.
2. Go to the [Personal Access Tokens settings page](https://github.com/settings/tokens), which is reachable via "Settings" > "Developer Settings" > "Personal access tokens".
3. Click "Generate new token".
4. Set a desired expiration date, or no expiration.
5. Check the "repo" checkbox. Check any other desired checkboxes.
6. Click "Generate token".
7. The webpage will display a long random string that is 40 characters long. Copy that string down now! Once you leave this page, GitHub will no longer display that token.

**Using a Personal Access Token**

A personal access token can be used on the command line whenever Git asks for a password. However, since the token is long and difficult to remember, a good option is to use Git's built-in credentials storage system. (GitHub recommends using the [Git Credential Manager Core](https://github.com/microsoft/Git-Credential-Manager-Core), but that is a separate piece of software from Git itself.)

The [Git Book](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage) describes Git's credentials system. The system supports two options: "cache" and "store". The "cache" option temporarily keeps credentials in memory (for 15 minutes, by default), after which they are purged; credentials do not get stored to disk. The more useful option, in my opinion, is the "store" option.

To use the "store" option, create a credentials file at `~/.git-credentials`. Enter a single line:

```
https://{username}:{personal_access_token}@github.com
```

Then run

```bash
git config --global credential.helper store
```

If you would like to store the credentials file elsewhere, run

```bash
git config --global credential.helper 'store --file /path/to/credentials/file'
```

Some users may be concerned with storing their personal access tokens in plaintext. However, I find this no different from storing private SSH keys locally in plaintext as well.

Once credentials are stored on disk and Git is configured to use the "store" option, then future Git push and pull commands should work without needing a password.
