#!/usr/bin/env bash

token=$(curl -XPOST -u jlong https://api.bootifulpodcast.online/token ) 
curl -H"Authorization: bearer $token " -XDELETE https://api.bootifulpodcast.online/admin/caches 