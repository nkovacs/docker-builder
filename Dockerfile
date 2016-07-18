FROM docker:dind

COPY builder-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/bin/sh", "/usr/local/bin/builder-entrypoint.sh"]
CMD []
