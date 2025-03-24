# Imagen base con PHP y Composer
FROM php:8.2-cli

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo mbstring exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Dar permisos a las carpetas de almacenamiento
RUN chmod -R 775 storage bootstrap/cache

# Exponer el puerto en el que Laravel escuchará
EXPOSE 8000

# Comando de inicio: Levantar Laravel con php artisan serve
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
