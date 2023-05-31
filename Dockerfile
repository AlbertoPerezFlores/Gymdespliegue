FROM php:7.4-apache


RUN apt update && apt install -y git 

WORKDIR /var/www/html

RUN echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/myapp.conf \
    && echo "    ServerName symfony.test" >> /etc/apache2/sites-available/myapp.conf \
    && echo "    DocumentRoot /var/www/html/project/public" >> /etc/apache2/sites-available/myapp.conf \
    && echo "" >> /etc/apache2/sites-available/myapp.conf \
    && echo "    <Directory /var/www/html/project/public>" >> /etc/apache2/sites-available/myapp.conf \
    && echo "        AllowOverride All" >> /etc/apache2/sites-available/myapp.conf \
    && echo "        Order Allow,Deny" >> /etc/apache2/sites-available/myapp.conf \
    && echo "        Allow from All" >> /etc/apache2/sites-available/myapp.conf \
    && echo "    </Directory>" >> /etc/apache2/sites-available/myapp.conf \
    && echo "</VirtualHost>" >> /etc/apache2/sites-available/myapp.conf


RUN a2ensite myapp.conf \
    && a2dissite 000-default.conf


RUN git clone https://github.com/AlbertoPerezFlores/polideportivo.git .

RUN chown -R www-data:www-data /var/www/html

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo 
RUN docker-php-ext-install pdo_mysql

RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip

#instalar composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer
RUN php /usr/bin/composer install 

# Copies your code to the image
# COPY /site /var/www/html
COPY . /var/www/html




EXPOSE $PORT
#CMD [“apache2ctl”, “-D”, “FOREGROUND”]



ENTRYPOINT apache2ctl -D 'FOREGROUND'



