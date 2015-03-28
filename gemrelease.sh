#!/bin/bash 

[[ $(git status -s | grep -v ?? | wc -l ) -gt 0 ]] && { echo "uncommited changes, can't continue"; exit 1; }

VERSION_FILE=./VERSION
RELEASE_TYPE=patch
[ ! -z "$1" ] && RELEASE_TYPE=$1

[ -z "$(git config user.name)" ] && git config user.name "CI User"
[ -z "$(git config user.email)" ] && git config user.email"ci.user@users.noreply.github.com"

GEMSPEC_FILE=$(ls -1 *.gemspec | head -1)

[ ! -f $GEMSPEC_FILE ] && { echo "no gemspec file"; exit 1; }
[ ! -d ./vendor/bundle/ruby ] && bundle install --deployment 

rm -f $VERSION_FILE && echo "Current Version is: $(bundle exec scmversion current )"

[ ! -f $VERSION_FILE ] &&  { echo "no version file"; exit 1; }

bundle exec scmversion bump $RELEASE_TYPE 
[[ $? -ne 0 ]] && { echo "Version Update Failed"; exit 1; }

RELEASE_VERSION=$(cat $VERSION_FILE)
GEM_FILE=$(echo $GEMSPEC_FILE | sed 's/\.gemspec//')-${RELEASE_VERSION}.gem

trap  "rm -f $GEM_FILE VERSION"  0 1 

echo "Deploying Release version: $RELEASE_VERSION"

[[ $? -ne 0 ]] && { echo "unable to update version file"; exit 1; } 
[ -z "$(bundle exec gem list kitchen-docker_ssh -q | grep "($RELEASE_VERSION)" )" ] && { echo "Version not updated"; exit 1; }

bundle exec gem build $GEMSPEC_FILE 
[[ $? -ne 0 ]] && { echo "Gem Build failed"; exit 1; }

if [ ! -f ~/.gem/credentials ]; then
  cat <<-EOF > ~/.gem/credentials
---
:rubygems_api_key: $RUBYGEMS_API_KEY
EOF
  chmod 0600 ~/.gem/credentials  
fi

bundle exec gem push $GEM_FILE --key rubygems 
[[ $? -ne 0 ]] && { echo "Gem Push failed"; exit 1; }

echo "Done"

exit 0
