FROM hub.df.ggg.com.vn/php-library/php:8.2

ENV WORK_DIR /var/www/html

WORKDIR ${WORK_DIR}

COPY ["./", "./"]

RUN cp ${WORK_DIR}/.env.example ${WORK_DIR}/.env

# Install & update packages
RUN composer install --no-dev --optimize-autoloader

# Permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

COPY ./docker/configs/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN php artisan key:generate

# dump autoload
#RUN composer dump-autoload

USER www-data

# RUN php artisan key:generate && \
#     php artisan config:clear && \
#     php artisan route:clear && \
#     php artisan cache:clear

# Expose the correct port for PHP-FPM
EXPOSE 9000
