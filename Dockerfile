FROM nginx:alpine
MAINTAINER S.Konoval <konsmt@gmail.com>
RUN apk update \
	&& apk add bash 
RUN cd //	
RUN mkdir /data
RUN chmod 7777 /data
RUN cd /data
RUN rm -rf /usr/share/nginx/html/*
COPY index.html /usr/share/nginx/html/index.html
RUN echo "#!/bin/bash "> /data/runsh.sh
RUN chmod +x /data/runsh.sh
RUN echo "echo 'My name is' "'$NAME'" ' and I am ' "'$AGE'" 'years old.'>> /usr/share/nginx/html/index.html ">> /data/runsh.sh
RUN echo "nginx -g 'daemon off;' ">>/data/runsh.sh
ENTRYPOINT ["/bin/bash","-c","/data/runsh.sh"]
