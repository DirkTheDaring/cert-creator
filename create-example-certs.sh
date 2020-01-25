#!/bin/bash
DIRNAME=$1
DIRNAME=${DIRNAME:="example"}

crt create workspace "$DIRNAME"
cd "$DIRNAME"
crt create ca-cert
crt update
mkdir publish
crt publish publish
