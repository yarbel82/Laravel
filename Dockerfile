FROM php:7.1
RUN apt-get update -y && apt-get install -y openssl zip unzip git libonig-dev graphviz 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install \
    pdo \
    mbstring \
    pdo_mysql

WORKDIR /app
COPY . /app
RUN composer install
RUN cp .env.example .env
RUN echo "" >> .env
RUN echo "JWT_SECRET=$(php artisan jwt:generate --show)" >> .env
RUN php artisan key:generate
RUN php artisan jwt:generate

CMD php artisan serve --host=0.0.0.0 --port=8181
EXPOSE 8181