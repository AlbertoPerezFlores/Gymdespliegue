FROM php:8.2-apache


RUN apt update && apt install -y git 

WORKDIR /var/www/html



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



