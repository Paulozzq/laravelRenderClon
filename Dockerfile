# Usar una imagen base con PHP, Composer y Node.js
FROM php:8.2-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    mariadb-server \
    netcat \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

RUN echo "APP_NAME=Laravel" >> .env && \
    echo "APP_ENV=local" >> .env && \
    echo "APP_KEY=" >> .env && \
    echo "APP_DEBUG=true" >> .env && \
    echo "APP_URL=http://localhost" >> .env && \
    echo "LOG_CHANNEL=stack" >> .env && \
    echo "DB_CONNECTION=mysql" >> .env && \
    echo "DB_HOST=127.0.0.1" >> .env && \
    echo "DB_PORT=3306" >> .env && \
    echo "DB_DATABASE=laravel" >> .env && \
    echo "DB_USERNAME=root" >> .env && \
    echo "DB_PASSWORD=root" >> .env

# Generar clave de aplicación
RUN php artisan key:generate

# Configurar MySQL
RUN service mysql start && \
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS laravel;"

# Ejecutar migraciones
RUN php artisan migrate --force

# Asignar permisos correctos
RUN chmod -R 775 storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache

# Exponer el puerto en el que Laravel escuchará
EXPOSE 80

# Iniciar MySQL y Laravel al arrancar el contenedor
CMD service mysql start && apache2-foreground
