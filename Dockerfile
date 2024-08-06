FROM php:8.3-fpm

#Pega os valores das variaveis dentro do docker-compose.yml
ARG user
ARG uid

# Instala as dependencias do sistema

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \ 
    zip \ 
    unzip \
    tar

# Limpar o cache das instalações
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions para rodar o laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Instalado o redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Set working directory
WORKDIR /var/www

#Qual o usuario poderá acessar o container
USER $user