FROM gradle:jdk11 as build

WORKDIR /app
COPY . .

USER root

RUN apt-get -qq update &&  apt-get -qqy --no-install-recommends install && \
		git ca-certificates libc6-dev libncurses5 libcurl4-openssl-dev && \
        apt -y autoremove && \
	    && rm -rf /var/lib/apt/lists/*


RUN chown -R gradle /app

USER gradle

RUN ./gradlew assemble

FROM gradle:jre11

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY --from=build /app/build/bin/linuxX64/releaseExecutable/solt.kexe /

RUN chown -R gradle /mnt

USER gradle

WORKDIR /mnt

ENTRYPOINT [ "/solt.kexe" ]
