#!/bin/bash
crt -w certs create
cd certs
crt ca-create
crt update
mkdir publish
crt publish publish
