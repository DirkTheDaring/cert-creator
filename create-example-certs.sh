#!/bin/bash
crt create workspace example
cd example
crt create ca-cert
crt update
mkdir publish
crt publish publish
