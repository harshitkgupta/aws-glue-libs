FROM centos
LABEL maintainer="Harshit Gupta <gphars@amazon.com>"
ENV MAVEN=https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz
ENV SPARK=https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-1.0/spark-2.4.3-bin-hadoop2.8.tgz
ENV GLUE=https://github.com/awslabs/aws-glue-libs.git
RUN mkdir glue
WORKDIR ./glue
RUN yum install -y python3 java-1.8.0-openjdk java-1.8.0-openjdk-devel tar git wget zip && \
    ln -s /usr/bin/python3 /usr/bin/python &&\
    ln -s /usr/bin/pip3 /usr/bin/pip &&\
    pip install pandas boto3 pynt &&\
    git clone -b glue-1.0 $GLUE  &&\
    wget $SPARK && wget $MAVEN &&\
    tar zxfv apache-maven-3.6.0-bin.tar.gz &&\
    tar zxfv spark-2.4.3-bin-hadoop2.8.tgz &&\
    rm spark-2.4.3-bin-hadoop2.8.tgz  && \
    rm apache-maven-3.6.0-bin.tar.gz &&\
    mv $(rpm -q -l java-1.8.0-openjdk-devel | grep "/bin$" | rev | cut -d"/" -f2- |rev) /usr/lib/jvm/jdk &&\
   # sed -i '/mvn -f/a rm /glue/aws-glue-libs/jarsv1/netty-*' aws-glue-libs/bin/glue-setup.sh &&\
   # sed -i '/mvn -f/a rm /glue/aws-glue-libs/jarsv1/javax.servlet-3.*' aws-glue-libs/bin/glue-setup.sh &&\
    yum clean all &&\
    rm -rf /var/cache/yum
ENV SPARK_HOME /glue/spark-2.4.3-bin-spark-2.4.3-bin-hadoop2.8
ENV MAVEN_HOME /glue/apache-maven-3.6.0
ENV JAVA_HOME /usr/lib/jvm/jdk
ENV GLUE_HOME /glue/aws-glue-libs
ENV PATH $PATH:$MAVEN_HOME/bin:$SPARK_HOME/bin:$JAVA_HOME/bin:$GLUE_HOME/bin
COPY jars
RUN sh aws-glue-libs/bin/glue-setup.sh
CMD ["bash"]
