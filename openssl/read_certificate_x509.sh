#!/bin/bash

FILE=$1

COUNT=0

print_certificate() {
   ((COUNT++))
   echo -e "\n##### CERTIFICATE ($COUNT) #####"
   #echo -e $CERT | openssl x509  -noout -subject -issuer -serial -fingerprint -enddate
   echo -e $CERT | openssl x509  -noout -subject | sed "s/^\([^=]*\).*\/CN=\([^\/$]*\).*/\1= \2/"
   echo -e $CERT | openssl x509  -noout -issuer | sed "s/^\([^=]*\).*\/CN=\([^\/$]*\).*/\1= \2/"
   echo -e $CERT | openssl x509  -noout -serial -fingerprint -enddate
   #echo -e $CERT | openssl x509  -noout -text
   #echo -e $CERT
}


CERT=""
while read line; do
   CERT=$(echo "$CERT\n$line")
   echo $line | grep -q "END CERTIF"
   if [ $? -eq 0 ] ; then
      print_certificate
      CERT=""
   fi
done < $FILE
