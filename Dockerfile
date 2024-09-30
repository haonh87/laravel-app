FROM hub.df.ggg.com.vn/php-library/laravel:php8.2-fpm

ENV WORK_DIR /var/www/html

COPY ./docker/configs/www.conf /usr/local/etc/php-fpm.d/www.conf

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

# RUN php artisan key:generate && \
#     php artisan config:clear && \
#     php artisan route:clear && \
#     php artisan cache:clear

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]
