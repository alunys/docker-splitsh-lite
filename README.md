# Docker Splitsh Lite

See [https://github.com/splitsh/lite](https://github.com/splitsh/lite)

## Description
Repository for a [docker image](https://hub.docker.com/repository/docker/alunys/docker-splitsh-lite) containing [splitsh-lite](https://github.com/splitsh/lite) binary, which creates standalone repositories for one or more sub-directories of a main repository.

Running the image enables to easily sync a sub-directory of the main repository to a standalone repository.  

## Vars
Env vars needed to run the image and make the synchronization :
* SSH_KEYSCAN_HOST: Host to retrieve a public key to if needed (ex: github.com)
* SSH_KEY: ssh key string to access the repositories if needed
* SOURCE_REPOSITORY: Main repository containing the sub-directories to split into standalone git repositories
* SOURCE_SPLIT_DIR: Directory to split into a standalone git repository
* SOURCE_BRANCH: branch to sync with the standalone git repository
* DESTINATION_REPOSITORY: Dedicated git repository

## Example:

Let's say we have a project on github at `git@github.com:my/project.git`  
The project contains a directory named `subdir`, we want to sync all the commits related with this directory to a standalone repository at `git@github.com:my/project-subdir.git`
```shell script
docker run --rm -e SSH_KEYSCAN_HOST=github.com -e SSH_KEY="$(cat ~/.ssh/ssh_key_for_github)" -e SOURCE_REPOSITORY="git@github.com:my/project.git" -e SOURCE_BRANCH="master" -e SOURCE_SPLIT_DIR="subdir" -e DESTINATION_REPOSITORY="git@github.com:my/project-subdir.git" alunys/docker-splitsh-lite
```
