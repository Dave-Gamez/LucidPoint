#! /bin/bash

sudo yum install -y httpd
sudo yum install -y wget
sudo yum install -y unzip
cd /var/www/html
sudo wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1-SrPNSJ09enApgfp0yRrEqgw8PmJpCg-' -O /var/www/html/index.zip
sudo wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1938nX2DrMDKqZdTSp4BcrCTM_3Ck6j7I' -O /var/www/html/index.html
sudo unzip -o index.zip
sudo service httpd restart
