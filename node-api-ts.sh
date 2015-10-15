#!/bin/sh

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

function show_help() {
  cat <<EOF
Usage: $(basename $0) [options] [ -p project_name ] [ -d docker_image_name ] output_directory

Options:
  -h        show this help
  -p        set project name
  -d        set docker image name
EOF
}

# Initialize our own variables:
project_name=""
docker_image_name=""

while getopts "h?p:d:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    p)  project_name=$OPTARG
        ;;
    d)  docker_image_name=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

output_directory=$1

if [ -d $output_directory ]; then
  echo "Output directory already exists!" 1>&2
  exit -1
fi

cp -a $(dirname $0)/node-api-ts $output_directory
git init $output_directory
pushd $output_directory > /dev/null

cat <<EOF > package.json
{
  "name": "$project_name",
  "version": "1.0.0",
  "description": "",
  "scripts": {
    "build": "rm -rf dist && tsc && babel es6 --out-dir dist && rm -rf es6",
    "pretest": "npm run build",
    "test": "./node_modules/jasmine-node/bin/jasmine-node --verbose dist/test/",
    "prestart": "npm run build",
    "start": "NODE_ENV=production node dist/app"
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "jasmine-node": "*"
  },
  "dependencies": {
    "restify": ">=4.0.3"
  },
  "private": true
}
EOF

popd > /dev/null
