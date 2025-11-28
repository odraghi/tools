#/bin/bash

if [ "x$1" = "x" ]
then
   echo -e "Create certificate for FQDN : \c"
   read CERTNAME
else
   CERTNAME=$1
   echo -e "Create certificate for : ${CERTNAME}"
fi

#CN=$(cut -d "." -f1 ${CERTNAME})
openssl req -new -x509 -days 365 -nodes -text -out ${CERTNAME}.crt -keyout ${CERTNAME}.key -subj "/CN=${CERTNAME}/O=${CERTNAME}" -addext "subjectAltName = DNS:${CERTNAME}"
cat ${CERTNAME}.{crt,key} > ${CERTNAME}.pem

echo "Genarating pkcs12 (.p12) ..."
openssl pkcs12 -export -inkey ${CERTNAME}.key -in ${CERTNAME}.crt -name ${CERTNAME} -out ${CERTNAME}.p12

ls -l ${CERTNAME}*
