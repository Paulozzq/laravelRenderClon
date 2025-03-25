# Usar una imagen oficial de PHP con soporte para Composer
FROM php:8.2-fpm

# Establecer el directorio de trabajo
WORKDIR /var/www

# Instalar dependencias necesarias (PostgreSQL, extensiones de PHP, Composer)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip \
    git \
    && docker-php-ext-install pdo pdo_pgsql \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar los archivos del proyecto
COPY . .

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Configurar las variables de entorno (como .env) de Laravel
RUN echo "APP_NAME=Laravel" >> .env
RUN echo "APP_ENV=local" >> .env
RUN echo "APP_KEY=base64:CYxZypwXFKB2R389b3GCzR4aTyV2DH7Zf94SzGt3yjY=" >> .env
RUN echo "APP_DEBUG=true" >> .env
RUN echo "APP_URL=http://localhost" >> .env
RUN echo "DB_CONNECTION=pgsql" >> .env
RUN echo "DB_HOST=dpg-cvh0a78gph6c73dal230-a" >> .env
RUN echo "DB_PORT=5432" >> .env
RUN echo "DB_DATABASE=lab2_wn2j" >> .env
RUN echo "DB_USERNAME=root" >> .env
RUN echo "DB_PASSWORD=iC41b28DdFWTg6HEbHzT9SmxAI6ghCXo" >> .env

# Generar la clave de la aplicación Laravel
RUN php artisan key:generate

# Ejecutar migraciones
RUN php artisan migrate --force

# Exponer el puerto en el que Laravel escuchará
EXPOSE 8000

# Comando para iniciar el servidor de Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
