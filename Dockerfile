FROM mongo:3.4.6

# Modify child mongo to use /data/seed as dbpath (because /data/db wont persist the build)
RUN mkdir -p /data/seed \
    && echo "dbpath = /data/seed" > /etc/mongodb.conf \
    && chown -R mongodb:mongodb /data/seed

RUN mkdir /seed

# Make /seed a volume to avoid to commit it
VOLUME /seed

COPY /data /seed

COPY /src/load/scripts /scripts

RUN mongod --fork --logpath /var/log/mongodb.log --dbpath /data/seed --smallfiles && \
    chmod +x /scripts/mongo-import.sh && \
    /scripts/mongo-import.sh && \
    mongod --dbpath /data/seed --shutdown && \
    chown -R mongodb:mongodb /data/seed

# Make the new dir a VOLUME to persists it
VOLUME /data/seed

CMD ["mongod", "--config", "/etc/mongodb.conf", "--smallfiles"]
