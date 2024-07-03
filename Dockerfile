# We pin a version tag here
FROM johanmarx/stratusolve_php_apache:230614

# Ensure we are in the correct directory for the container
WORKDIR /var/www/html/

# Copy all the files from the current directory to the container working directory
COPY --chown=www-data:www-data  . .