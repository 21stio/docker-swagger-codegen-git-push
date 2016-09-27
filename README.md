#### description

clones the repository, generates a sdk from a swagger.(yaml|json), adds and commits everything, increments the version tag (+ 0.0.1) and pushes everything to the remote repository

#### usage

```bash
docker run \
	-v $(pwd)/swagger.yaml:/swagger.yaml \
	-v /Users/jonhdoe/.ssh/id_rsa:/id_rsa \
	-e GIT_HOST=github.com
	-e GIT_USERNAME=foouser
	-e GIT_EMAIL=foouser@bar.com
	-e SSH_KEY_FILE=/id_rsa \
	-e GIT_REPOSITORY=git@github.com:foouser/bar-repo.git
	-e CODEGEN_SWAGGER_FILE=/swagger.yaml \
	-e CODEGEN_LANGUAGE=go \
	21stio/swagger-codegen-git-push
```
