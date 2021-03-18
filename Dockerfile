FROM openjdk:8
# https://github.com/docker-library/openjdk/issues/145#issuecomment-334561903
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=894979
RUN rm /etc/ssl/certs/java/cacerts ; update-ca-certificates -f

RUN mkdir -p /opt/secor

# Prepare environment
ENV SECOR_HOME=/opt/secor
WORKDIR $SECOR_HOME

RUN groupadd --system --gid=9999 secor && \
    useradd --system --home-dir $SECOR_HOME --uid=9999 --gid=secor secor

RUN chown -R secor:secor $SECOR_HOME
USER secor

ADD target/secor-*-bin.tar.gz $SECOR_HOME

COPY src/main/scripts/docker-entrypoint.sh $SECOR_HOME/docker-entrypoint.sh
RUN chmod +x $SECOR_HOME/docker-entrypoint.sh
ENTRYPOINT ["$SECOR_HOME/docker-entrypoint.sh"]