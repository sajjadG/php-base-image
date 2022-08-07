ARG CGI_SERVER
ARG PHP_VERSION=8.1
FROM php:${PHP_VERSION}-${CGI_SERVER}

# Install system and extension dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    vim \
    curl \
    unzip \
    supervisor \
    build-essential \
    libpq-dev \
    libzip-dev \
    libssl-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    apt-transport-https \
    gnupg2

# Install PECL extensions
RUN pecl install redis \
    && docker-php-ext-enable redis

# Install PHP extensions
RUN docker-php-ext-configure intl

# NOTE: for php image version 7.2 and lower change to --with-jpeg-dir and --with-freetype-dir
RUN docker-php-ext-configure gd \
    --with-jpeg=/usr/include/ \
    --with-freetype=/usr/include/

RUN docker-php-ext-install -j$(nproc) \
    gd mysqli pcntl pdo_mysql soap zip bcmath exif intl sockets pgsql pdo_pgsql

# Get latest Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Keep ARG closer to where it's going to be used for more effcient use of layer caching
ARG NODE_VERSION=None

# Install nodejs 
RUN if [ "$NODE_VERSION" != "None" ] ; then curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    && apt-get install -y nodejs ; fi

# Install MS ODBC Driver for SQL Server
### Commented due to EULA. also you may need to change the debian version to 10 for older php images
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
#     && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
#     && apt-get update \
#     && ACCEPT_EULA=Y apt-get -y --no-install-recommends install unixodbc-dev msodbcsql17 \
#     && apt-get -y install freetds-bin \
#     && pecl install sqlsrv \
#     && pecl install pdo_sqlsrv \
#     && echo "extension=pdo_sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini \
#     && echo "extension=sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-sqlsrv.ini \
#     && sed -i -E 's/(CipherString\s*=\s*DEFAULT@SECLEVEL=)2/\11/' /etc/ssl/openssl.cnf

# Cleanup
RUN apt-get autoremove && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
