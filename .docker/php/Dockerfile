FROM php:8.2-fpm-bookworm

ENV USER=fbxweb
ENV GROUP=fbxweb

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libmagickwand-dev \
    doxygen \
    graphviz \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install zip pdo_mysql mbstring exif pcntl bcmath gd

# Install Postgre PDO
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Imagick PHP extension
RUN pecl install imagick && docker-php-ext-enable imagick

# Composer (pinar na v2)
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Node.js 20 LTS (sem setup_X; repositório "nodistro" da NodeSource)
RUN apt-get update && apt-get install -y ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
    > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y nodejs \
    && node -v && npm -v \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup working directory
WORKDIR /var/www/

# Create User and Group
RUN groupadd -g 1000 ${GROUP} && useradd -u 1000 -ms /bin/bash -g ${GROUP} ${USER}

# Grant Permissions
RUN chown -R ${USER} /var/www

# Select User
USER ${USER}

# Copy permission to selected user
COPY --chown=${USER}:${GROUP} . .

EXPOSE 9000
CMD ["php-fpm"]
