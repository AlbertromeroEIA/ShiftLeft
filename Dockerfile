FROM registry.access.redhat.com/ubi7/ubi:7.7
ENV JBOSS_HOME=/opt/jboss
RUN useradd -m -G wheel jboss && echo "jboss:password123" | chpasswd
RUN yum install -y java-1.8.0-openjdk unzip && yum clean all
COPY jboss-eap-7.2.0.zip /tmp/
RUN unzip /tmp/jboss-eap-7.2.0.zip -d /opt && mv /opt/jboss-eap-7.2 $JBOSS_HOME && rm /tmp/jboss-eap-7.2.0.zip
RUN ${JBOSS_HOME}/bin/add-user.sh -u admin -p admin123 --silent
RUN echo 'JAVA_OPTS="$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0"' >> ${JBOSS_HOME}/bin/standalone.conf
EXPOSE 8080 9090 9990
RUN chown -R jboss:0 ${JBOSS_HOME}
USER jboss
ENTRYPOINT ["/opt/jboss/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
