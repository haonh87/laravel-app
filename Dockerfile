FROM hub.df.ggg.com.vn/php-library/php:8.2-fpm-nginx

ENV WORK_DIR /var/www/html

WORKDIR ${WORK_DIR}

COPY . .

# Install & update packages
RUN composer install --no-dev --optimize-autoloader

# Permissions
RUN chown -R www-data:www-data ${WORK_DIR} \
    && chmod -R 775 ${WORK_DIR}/storage \
    && chmod -R 775 ${WORK_DIR}/bootstrap/cache


RUN cp ${WORK_DIR}/.env.example ${WORK_DIR}/.env

# Generate key
RUN php artisan key:generate

EXPOSE 80 443