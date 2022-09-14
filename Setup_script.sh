#! /bin/bash

sudo yum install -y httpd
sudo yum install -y wget
sudo yum install -y unzip
cd /var/www/html
sudo wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1HRrO4pFRdVVrw5wEpgPdBw70-H_ty0pe' -O /var/www/html/index.zip
sudo wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1EKtIBUrCdhP5YTeTvC_aD4xHEHVTNFbJ' -O /var/www/html/index.html
sudo unzip -o index.zip
cp /var/www/html/index.html /var/www/html/index.htm
sudo service httpd restart
