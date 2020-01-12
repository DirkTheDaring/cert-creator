#!/usr/bin/env bash

##############################################################################
function recursive_config_search
{
  local NAME=$1
  local DIRNAME=""

  if [ -d "${NAME}/.certificates" ]; then
    echo ${NAME}
    return 0
  fi

  if [ "${NAME}" == "/" ]; then
    return 1
  fi

  DIRNAME=$(dirname "${NAME}")

  recursive_config_search "${DIRNAME}"
}
##############################################################################
function create_config
{
#ORGANISATION=${ORGANISATION:="@@@@_SELF_SIGNED_CERTIFICATE_@@@@"}
#COMMON_NAME=${COMMON_NAME:="@@@@_SELF_SIGN_ROOT_CERTIFICATE_AUTHORITY_@@@@"}

ORGANISATION=${ORGANISATION:="@@@@-SELF-SIGNED-CERTIFICATE-@@@@"}
COMMON_NAME=${COMMON_NAME:="@@@@-SELF-SIGN-ROOT-CERTIFICATE-AUTHORITY-@@@@"}


cat<<EOF
COUNTRY=DE
STATE=Bavaria
LOCATION=Munich
ORGANISATION=${ORGANISATION}
COMMON_NAME=${COMMON_NAME}
OU=office
EMAIL=test@example.com
EOF
}
##############################################################################


function create_subjectAltName()
{
	NAME=$1
	DNS_LIST=$2
	IP_LIST=$3

#	echo $NAME
#	echo $DNS_LIST
#	echo $IP_LIST


	LIST="DNS:$NAME"

	for DNS in $DNS_LIST;
	do
		LIST="$LIST, DNS:$DNS"		
	done

	for IP in $IP_LIST;
	do
		LIST="$LIST, IP:$IP"		
	done

	echo $LIST
}
##############################################################################

function create_certificate_request
{
	OPENSSL_CONFIG_FILE="$1"
	KEY_FILE="$2"
        CSR_FILE="$3"
	SUBJECT="$4"
	subjectAltName="$5"
	DAYS="$6"
	

	#echo $OPENSSL_CONFIG_FILE, $KEY_FILE, $CSR_FILE

	# subjectAltName is picked up in the OPENSSL_CONFIG_FILE
	export subjectAltName
	#-days "$DAYS"\
	
	openssl req\
	-new\
	-nodes\
	-reqexts v3_req\
	-config "$OPENSSL_CONFIG_FILE"\
	-subj "$SUBJECT"\
	-key "$KEY_FILE"\
	-out "$CSR_FILE"\
	-sha256
#	>/dev/null 2>&1
	
	return $?
}
##############################################################################

function dump_csr
{
	CSR_FILE="$1"
	openssl req -in "$CSR_FILE" -noout -text -nameopt multiline,show_type 2>&1
	echo $?
}
##############################################################################

function create_certificate_key
{
	KEY_FILE_NAME="$1"
	KEY_LENGTH="$2"

	openssl genrsa\
	-out "$KEY_FILE_NAME"\
	"$KEY_LENGTH"\
	>/dev/null 2>&1

	RET=$?
	chmod 0400 "$KEY_FILE_NAME"
	echo $RET
}
##############################################################################

function dump_csr
{
	CSR_FILE="$1"
	openssl req -in "$CSR_FILE" -noout -text -nameopt multiline,show_type 2>&1
	echo $?
}
##############################################################################

function dump_crt
{
	CRT_FILE="$1"
	openssl x509 -in "$CRT_FILE" -noout -text -nameopt dump_all,multiline,show_type 2>&1
	echo $?
}
