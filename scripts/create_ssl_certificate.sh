#!/bin/bash
# 「*.dummy.example.com」に対する自己証明書を作成するシェルスクリプト

set -eu

SCRIPT_DIR="$(cd $(dirname ${0}) && pwd)";
CERTS_DIR="${SCRIPT_DIR}/certs"
CSR_DIR="${SCRIPT_DIR}/csr"

### SSL 証明書の設定 ##################################################################
## RSA 鍵長
RSA_KEY_LENGTH="2048"

## Configure self signed CA cert and key
CA_CSR_CN="ansible-roles-v2_nginx_CA_Certificate"
CA_SSL_BASE_NAME="self-ca"
CA_PRIVATE_KEY_PEM="${CA_SSL_BASE_NAME}_private-key.pem"
CA_CSR_PEM="${CA_SSL_BASE_NAME}_csr.pem"
CA_CERT_KEY_PEM="${CA_SSL_BASE_NAME}_cert-key.pem"

## Configure key and cert for *.dummy.example.com
DUMMY_CSR_CN="*.dummy.example.com"
DUMMY_SSL_BASE_NAME="$(echo -n "${DUMMY_CSR_CN}" | sed "s/^\*/_/g")"
DUMMY_PRIVATE_KEY_PEM="${DUMMY_SSL_BASE_NAME}_private-key.pem"
DUMMY_CSR_PEM="${DUMMY_SSL_BASE_NAME}_csr.pem"
DUMMY_CERT_KEY_PEM="${DUMMY_SSL_BASE_NAME}_cert-key.pem"
FULLCHAIN_DUMMY_CERT_KEY_PEM="${DUMMY_SSL_BASE_NAME}_fullchain-cert-key.pem"

## Prepare
mkdir -p "${CERTS_DIR}"
mkdir -p "${CSR_DIR}"

### SSL 証明書の作成 ##################################################################
## Generate self signed CA cert and key
openssl genrsa -out "${CERTS_DIR}/${CA_PRIVATE_KEY_PEM}" "${RSA_KEY_LENGTH}";
openssl req -utf8 -new -sha256 \
        -key "${CERTS_DIR}/${CA_PRIVATE_KEY_PEM}" \
        -subj "/CN=${CA_CSR_CN}" \
        -out "${CSR_DIR}/${CA_CSR_PEM}";
openssl x509 -req \
        -in "${CSR_DIR}/${CA_CSR_PEM}" \
        -signkey "${CERTS_DIR}/${CA_PRIVATE_KEY_PEM}" \
        -days 3600 \
        -out "${CERTS_DIR}/${CA_CERT_KEY_PEM}";

## Generate key and cert for *.dummy.example.com
openssl genrsa -out "${CERTS_DIR}/${DUMMY_PRIVATE_KEY_PEM}" "${RSA_KEY_LENGTH}";
openssl req -utf8 -new -sha256 \
        -key "${CERTS_DIR}/${DUMMY_PRIVATE_KEY_PEM}" \
        -subj "/CN=${DUMMY_CSR_CN}" \
        -out "${CSR_DIR}/${DUMMY_CSR_PEM}";
openssl x509 -req \
        -in "${CSR_DIR}/${DUMMY_CSR_PEM}" \
        -CA "${CERTS_DIR}/${CA_CERT_KEY_PEM}" \
        -CAkey "${CERTS_DIR}/${CA_PRIVATE_KEY_PEM}" \
        -set_serial 01 \
        -days 3600 \
        -out "${CERTS_DIR}/${DUMMY_CERT_KEY_PEM}";

## Generate fullchain cert pem file
cat "${CERTS_DIR}/"{"${DUMMY_CERT_KEY_PEM}","${CA_CERT_KEY_PEM}"} \
        > "${CERTS_DIR}/${FULLCHAIN_DUMMY_CERT_KEY_PEM}"

## Change permission
chmod 600 "${CERTS_DIR}/"{"${DUMMY_PRIVATE_KEY_PEM}","${CA_PRIVATE_KEY_PEM}"}
chmod 644 "${CERTS_DIR}/"{"${CA_CERT_KEY_PEM}","${DUMMY_CERT_KEY_PEM}","${FULLCHAIN_DUMMY_CERT_KEY_PEM}"}


# chmod 0600 "${CERTS_DIR}/"{ca-key,server-key}.pem
# chmod 0644 "${CERTS_DIR}/"{ca,server-cert,fullchain}.pem
