FROM quay.io/ceph/ceph:v19.2.3

ARG GANESHA_REPO_BASEURL="https://buildlogs.centos.org/centos/\$releasever-stream/storage/\$basearch/nfsganesha-9/"

# Add NFS-Ganesha repo
RUN \
    echo "[ganesha]" > /etc/yum.repos.d/ganesha.repo && \
    echo "name=ganesha" >> /etc/yum.repos.d/ganesha.repo && \
    echo "baseurl=${GANESHA_REPO_BASEURL}" >> /etc/yum.repos.d/ganesha.repo && \
    echo "gpgcheck=0" >> /etc/yum.repos.d/ganesha.repo && \
    echo "enabled=1" >> /etc/yum.repos.d/ganesha.repo

# NFS-Ganesha
RUN echo "\
dbus-daemon \
nfs-ganesha-ceph \
nfs-ganesha-rados-grace \
nfs-ganesha-rados-urls \
nfs-ganesha-rgw \
nfs-ganesha \
rpcbind \
sssd-client" >> packages.txt

RUN echo "=== PACKAGES TO BE INSTALLED ==="; cat packages.txt
RUN echo "=== INSTALLING ===" ; \
dnf install -y --setopt=install_weak_deps=False --setopt=skip_missing_names_on_install=False --enablerepo=crb $(cat packages.txt) && dnf clean all
