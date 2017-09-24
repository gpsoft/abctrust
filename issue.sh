#!/bin/sh

# 
if [ -z "${SITE_HOST}" ]; then
    SITE_HOST=localhost
fi

ROOTCA_NAME="ABC Dummy Root CA"
ROOTCA_ORG="ABC Dummy Trust Corp."
ROOTCA_DIR=rootCA
SITE_DIR=site
export OPENSSL_CONF=$(pwd)/openssl.cnf

if [ ! -d "${ROOTCA_DIR}" ]; then
    echo ""
    echo "##### Creating ${ROOTCA_NAME}"
    mkdir -p ${ROOTCA_DIR}/out
    touch ${ROOTCA_DIR}/index.txt
    openssl genrsa -out ${ROOTCA_DIR}/rootkey.pem 2048
    openssl req -new -key ${ROOTCA_DIR}/rootkey.pem \
        -out ${ROOTCA_DIR}/root.csr \
        -batch -subj "/CN=${ROOTCA_NAME}/O=${ROOTCA_ORG}/C=JP"
    openssl ca -create_serial \
        -out ${ROOTCA_DIR}/rootcert.pem \
        -days 3650 \
        -batch \
        -keyfile ${ROOTCA_DIR}/rootkey.pem \
        -selfsign \
        -extensions v3_ca \
        -infiles ${ROOTCA_DIR}/root.csr
    if [ $? -ne 0 ]; then exit; fi
fi

echo ""
echo "##### Issuing certificate for ${SITE_HOST}"
mkdir -p ${SITE_DIR}
openssl genrsa -out ${SITE_DIR}/sitekey.pem 2048
openssl req -new -key ${SITE_DIR}/sitekey.pem \
    -out ${SITE_DIR}/site.csr \
    -batch -subj "/CN=${SITE_HOST}/C=JP"
openssl ca \
    -out ${SITE_DIR}/sitecert.pem \
    -batch \
    -infiles ${SITE_DIR}/site.csr

if [ $? -eq 0 ]; then
    echo ""
    echo "##### Done!"
    echo "The Root CA:"
    echo "  Private key: ${ROOTCA_DIR}/rootkey.pem"
    echo "  Certificate: ${ROOTCA_DIR}/rootcert.pem"
    echo "The Site:"
    echo "  Private key: ${SITE_DIR}/sitekey.pem"
    echo "  Certificate: ${SITE_DIR}/sitecert.pem"
fi
