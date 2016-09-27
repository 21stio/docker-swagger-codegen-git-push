#!/usr/bin/env sh

set -e

if [ "$1" = '-h' ]  || [ -z ${SSH_KEY_FILE+x} ] || [ -z ${GIT_HOST+x} ] || [ -z ${GIT_EMAIL+x} ] || [ -z ${GIT_USERNAME+x} ] || [ -z ${GIT_REPOSITORY+x} ] || [ -z ${CODEGEN_SWAGGER_FILE+x} ] || [ -z ${CODEGEN_LANGUAGE+x} ]; then
	echo "environment variables SSH_KEY_FILE, GIT_HOST, GIT_EMAIL, GIT_USERNAME, GIT_REPOSITORY, CODEGEN_SWAGGER_FILE and CODEGEN_LANGUAGE need to be set"
	exit
fi

mkdir ~/.ssh
printf "Host ${GIT_HOST}\n  HostName ${GIT_HOST}\n  Port 22\n  IdentityFile ${SSH_KEY_FILE}\n\n" >>  ~/.ssh/config
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

git clone $GIT_REPOSITORY /cloned

java -jar swagger-codegen-cli.jar generate --input-spec ${CODEGEN_SWAGGER_FILE} --lang ${CODEGEN_LANGUAGE} --output /cloned

cd /cloned

git config --global user.email ${GIT_EMAIL}
git config --global user.name ${GIT_USERNAME}

git add .
git commit -m "update"

CURRENT_TAG_VERSION=$(git describe --tags $(git rev-list --tags --max-count=1 2>/dev/null) 2>/dev/null || echo "0.0.0")
NEW_TAG_VERSION=$(/./increment_version.sh -p ${CURRENT_TAG_VERSION})

git tag -a ${NEW_TAG_VERSION} -m "update"

git push
git push origin --tags