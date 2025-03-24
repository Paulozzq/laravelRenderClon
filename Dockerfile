# Imagen base con PHP y Composer
FROM php:8.2-cli

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpq-dev \
    postgresql \
    && docker-php-ext-install pdo pdo_pgsql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Crear archivo .env manualmente dentro del contenedor
RUN echo "APP_NAME=Laravel" > .env && \
    echo "APP_ENV=local" >> .env && \
    echo "APP_KEY=" >> .env && \
    echo "APP_DEBUG=true" >> .env && \
    echo "APP_URL=http://localhost" >> .env && \
    echo "LOG_CHANNEL=stack" >> .env && \
    echo "DB_CONNECTION=pgsql" >> .env && \
    echo "DB_HOST=127.0.0.1" >> .env && \
    echo "DB_PORT=5432" >> .env && \
    echo "DB_DATABASE=laravel" >> .env && \
    echo "DB_USERNAME=postgres" >> .env && \
    echo "DB_PASSWORD=postgres" >> .env

# Generar clave de aplicación
RUN php artisan key:generate

# Iniciar PostgreSQL y crear la base de datos
RUN service postgresql start && \
    sudo -u postgres psql -c "CREATE DATABASE laravel;" && \
    sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"

# Ejecutar migraciones de Laravel
RUN php artisan migrate --force

# Asignar permisos correctos
RUN chmod -R 775 storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache

# Exponer el puerto 8000 para Laravel
EXPOSE 8000

# Comando de inicio: Levantar Laravel con php artisan serve
CMD service postgresql start && php artisan serve --host=0.0.0.0 --port=8000
