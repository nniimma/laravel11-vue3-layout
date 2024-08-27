#Processo da base
#FROM rockylinux:8.8-minimal as base
#RUN microdnf install dnf -y
FROM rockylinux:8.9 as base
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm http://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf update -y --nodocs --setopt install_weak_deps=False && \
    dnf module reset php -y && \
    dnf -y module install php:remi-8.2 && \
    dnf -y install --nodocs --setopt install_weak_deps=False vim make telnet openssl wget nginx ImageMagick ImageMagick-devel \
    php php-zip php-mysqlnd php-curl php-pdo php-pdo-dblib php-{cli,common,pear,cgi,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,opcache,imagick,xmlrpc,readline,memcached,redis,apcu,dom,memcache} && \
    curl -s -L https://rpm.nodesource.com/setup_20.x | bash -s && \
    dnf -y install --nodocs --setopt install_weak_deps=False nodejs && \
    dnf clean all && rm -rf /var/cache/yum && rm -rf /var/cache/yum
RUN wget https://getcomposer.org/installer -O composer-installer.php
RUN php composer-installer.php --filename=composer --install-dir=/usr/local/bin
RUN sed -i 's/error_log .*;/error_log \/dev\/stderr;/g' /etc/nginx/nginx.conf && \
    sed -i 's/access_log .*;/access_log \/dev\/stdout;/g' /etc/nginx/nginx.conf
RUN rm -rf /etc/nginx/sites-available /etc/nginx/sites-enabled && \
    mkdir -p /run/php-fpm/ && \
    mkdir -p /var/run/php
RUN sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf && \
    sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf && \
    sed -i '/listen = \/var\/php-fpm\/www.sock/a listen.group = nginx' /etc/php-fpm.d/www.conf &&\
    sed -i '/listen = \/var\/php-fpm\/www.sock/a listen.owner = nginx' /etc/php-fpm.d/www.conf
STOPSIGNAL SIGQUIT
COPY docker/entrypoint /entrypoint
RUN chmod +x /entrypoint

#Processo para dev/staging
FROM base as staging
ENV COMPOSER_ALLOW_SUPERUSER=1
WORKDIR /app
CMD ["/entrypoint", "staging"]

#Processo para produção
FROM base as prod
ENV COMPOSER_ALLOW_SUPERUSER=1
WORKDIR /app
COPY . /app
RUN composer install --optimize-autoloader --no-dev
# RUN php artisan config:cache && \
#     php artisan route:cache && \
#     php artisan event:cache && \
#     php artisan view:cache
#RUN php artisan inertia:start-ssr

RUN chown -R nginx:nginx /app
RUN chmod -R 775 /app/storage
RUN chmod -R 775 /app/bootstrap/cache

COPY docker/nginx.conf /etc/nginx/.
CMD ["/entrypoint", "prod"]

