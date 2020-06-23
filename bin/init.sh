#!/bin/bash

FILE=.env
if test -f "$FILE"; then
    echo "$FILE already exists."
    exit
fi

read -p "Project name: " project_name
read -p "Project url [$project_name.devlocal]: " url
read -p "Public folder [public]: " folder
url=${url:-$project_name.devlocal}
folder=${folder:-public}

cp -n .env.dist $FILE
sed -i "" "s|projectname|$project_name|g" $FILE
sed -i "" "s|local.devlocal|$url|g" $FILE
sed -i "" "s|public|$folder|g" $FILE

echo Project configured
echo name: $project_name
echo folder: $folder
echo url: https://$url

docker-compose up -d