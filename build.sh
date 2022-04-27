#!/bin/bash
set -euo pipefail

PHP_VERSIONS=('7.4-apache' '7.4-fpm' '8.0-apache' '8.0-fpm' '8.1-apache' '8.1-fpm')
NODE_VERSIONS=('12' '14' '16' '18')
REPOSITORY_NAME=sajjadg
IMAGE_NAME=php-base-image

for PHP_VERSION in "${PHP_VERSIONS[@]}"
do
    for NODE_VERSION in "${NODE_VERSIONS[@]}"
    do        
        echo ">>>>>>> Building ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION} <<<<<<<"
        docker build \
        --build-arg PHP_VERSION=${PHP_VERSION} \
        --tag ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION} \
        .

        docker push ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION}

        echo ">>>>>>> Building ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION}-node${NODE_VERSION} <<<<<<<"
        docker build \
        --build-arg PHP_VERSION=${PHP_VERSION} \
        --build-arg NODE_VERSION=${NODE_VERSION} \
        --tag ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION}-node${NODE_VERSION} \
        .

        docker push ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION}-node${NODE_VERSION}
    done
done