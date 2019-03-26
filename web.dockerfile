FROM nginx:1.10

ADD ./vhost.conf /etc/nginx/conf.d/default.conf
# ADD ./rest_builder.conf /etc/nginx/conf.d/rest_builder.zenwel.local.conf

# RUN apt-get update
# RUN apt-get install -y \
#     git \
#     vim-tiny \
#     openssh-client

# RUN mkdir -p /root/.ssh
# ADD id_rsa_zenwel-api /root/.ssh/id_rsa
# ADD id_rsa_zenwel-api.pub /root/.ssh/id_rsa.pub
# RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
# RUN chmod 600 /root/.ssh/id_rsa
# RUN chmod 600 /root/.ssh/authorized_keys \
#     && eval "$(ssh-agent -s)"  \
#     && ssh-add ~/.ssh/id_rsa \
#     && ssh-keyscan github.com > /root/.ssh/known_hosts

# RUN echo "root:Docker!" | chpasswd

WORKDIR /var/www