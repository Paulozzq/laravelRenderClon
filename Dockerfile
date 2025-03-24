# Imagen base con PHP y Composer
FROM php:8.2-cli

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Configurar el archivo .env con PostgreSQL
RUN echo "APP_NAME=Laravel" > .env && \
    echo "APP_ENV=production" >> .env && \
    echo "APP_KEY=" >> .env && \
    echo "APP_DEBUG=false" >> .env && \
    echo "APP_URL=http://localhost" >> .env && \
    echo "LOG_CHANNEL=stack" >> .env && \
    echo "DB_CONNECTION=pgsql" >> .env && \
    echo "DB_HOST=${DATABASE_HOST}" >> .env && \
    echo "DB_PORT=${DATABASE_PORT}" >> .env && \
    echo "DB_DATABASE=${DATABASE_NAME}" >> .env && \
    echo "DB_USERNAME=${DATABASE_USER}" >> .env && \
    echo "DB_PASSWORD=${DATABASE_PASSWORD}" >> .env

# Generar clave de aplicación
RUN php artisan key:generate

# Ejecutar migraciones de Laravel
RUN php artisan migrate --force || true

# Asignar permisos correctos
RUN chmod -R 775 storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache

# Exponer el puerto 8000
EXPOSE 8000

# Comando de inicio: Levantar Laravel con php artisan serve
CMD php artisan serve --host=0.0.0.0 --port=8000
