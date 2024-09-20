FROM hub.df.ggg.com.vn/php-library/php:8.2-fpm

ENV WORK_DIR /var/www/html

WORKDIR ${WORK_DIR}

COPY ["./", "./"]

# Install & update packages
# RUN composer install --no-scripts

# dump autoload
#RUN composer dump-autoload

# RUN cp ${WORK_DIR}/.env.example ${WORK_DIR}/.env

# RUN php artisan key:generate && \
#     php artisan config:clear && \
#     php artisan route:clear && \
#     php artisan cache:clear

# Expose the correct port for PHP-FPM
EXPOSE 9000
