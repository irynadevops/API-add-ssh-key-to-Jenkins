#!/bin/bash

## Variables
JENKINS_URL=<write Jenkins url>
USER=<see in Jenkins>
TOKEN=<add in Jenkis for your user>
NAMESPACE=<write namespace>
KEY_NAME=<write key name>
KEY_DATA=<write private key>

## Get Jenkins crumb
JENKINS_CRUMB=$(curl -k -u "$USER:$TOKEN" 'https://$JENKINS_URL/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)')

## Api request to create new ssh key credential in Jenkins
curl -k -X POST -u $USER:$TOKEN -H "${JENKINS_CRUMB}" "https://$JENKINS_URL/credentials/store/system/domain/_/createCredentials" --data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "'"$NAMESPACE-$KEY_NAME"'",
    "username": "'"$NAMESPACE-$KEY_NAME"'",
    "password": "",
    "privateKeySource": {
      "stapler-class": "com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey$DirectEntryPrivateKeySource",
      "privateKey": "'"$KEY_DATA"'",
    },
    "description": "'"$NAMESPACE-$KEY_NAME"'",
    "stapler-class": "com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey"
  }
}'
