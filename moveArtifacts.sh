#!/bin/bash

#AppList=$1
ArtifactsFolder="../artifacts"
SourceFolder="../tmp"
AppList="JobGrid"

if [ $AppList == "JobGrid" ]; then
  AppList=`sed 's/\[\(.*\)\]/\1/g' ../config/AppList.yaml`
fi

echo $AppList

for App in $(echo $AppList | sed -n 1'p' | tr ',' '\n')
do
  if [ ! -f $SourceFolder/$App.zip ]; then
    echo "Artifact $SourceFolder/$App.zip does not exist. Deployment failed..."
    exit 1
  fi
  rm -rf $ArtifactsFolder/$App
  unzip $SourceFolder/$App.zip -d $ArtifactsFolder
  if [ $? -eq 0 ]; then
    echo "Artifacts staged successfully for $App."
  else
    echo "Artifacts failed to copy for $App"
  fi
done
