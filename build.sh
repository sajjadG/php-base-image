#!/bin/bash
set -euo pipefail

REPOSITORY_NAME=sajjadg
IMAGE_NAME=php-base-image
CGI_SERVERS=('apache' 'fpm')
PHP_VERSIONS=('7.4' '8.0' '8.1')
NODE_VERSIONS=('12' '14' '16' '18')

for CGI_SERVER in "${CGI_SERVERS[@]}"
do
    for PHP_VERSION in "${PHP_VERSIONS[@]}"
    do
        echo ">>>>>>> Building ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION}-${CGI_SERVER} <<<<<<<"
        docker build \
        --build-arg CGI_SERVER=${CGI_SERVER} \
        --build-arg PHP_VERSION=${PHP_VERSION} \
        --tag ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION}-${CGI_SERVER} \
        .

        docker push ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION}-${CGI_SERVER}

        for NODE_VERSION in "${NODE_VERSIONS[@]}"
        do        

            echo ">>>>>>> Building ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION}-${CGI_SERVER}-node${NODE_VERSION} <<<<<<<"
            docker build \
            --build-arg CGI_SERVER=${CGI_SERVER} \
            --build-arg PHP_VERSION=${PHP_VERSION} \
            --build-arg NODE_VERSION=${NODE_VERSION} \
            --tag ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION}-${CGI_SERVER}-node${NODE_VERSION} \
            .

            docker push ${REPOSITORY_NAME}/${IMAGE_NAME}:php${PHP_VERSION}-${CGI_SERVER}-node${NODE_VERSION}
        done
    done
done