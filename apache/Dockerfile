FROM httpd:2.4

# Enable required modules
RUN sed -i \
    -e 's/^#LoadModule proxy_module/LoadModule proxy_module/' \
    -e 's/^#LoadModule proxy_fcgi_module/LoadModule proxy_fcgi_module/' \
    -e 's/^#LoadModule proxy_http_module/LoadModule proxy_http_module/' \
    -e 's/^#LoadModule rewrite_module/LoadModule rewrite_module/' \
    /usr/local/apache2/conf/httpd.conf

# Copy custom configuration
COPY 000-default.conf /usr/local/apache2/conf/sites/
RUN echo "Include conf/sites/*.conf" >> /usr/local/apache2/conf/httpd.conf
