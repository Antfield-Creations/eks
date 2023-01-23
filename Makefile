BINDIR ?= ~/.local/bin
INSTALLDIR ?= ~/.local/aws-cli

tools: kubectl helm aws-cli eksctl

kubectl:
	# Install kubectl
	which kubectl || curl -fSL "https://dl.k8s.io/release/$(shell curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o ${BINDIR}/kubectl
	which kubectl || chmod +x ${BINDIR}/kubectl
	# Since we may not have a cluster yet, we ask only the kubectl client side version
	kubectl version --client

helm:
	# Install helm
	which helm || USE_SUDO=false HELM_INSTALL_DIR=${BINDIR} curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
	helm version

aws-cli:
	which aws || { \
		curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
		unzip /tmp/awscliv2.zip -d /tmp/ && \
		/tmp/aws/install --bin-dir ${BINDIR} --install-dir ${INSTALLDIR} --update && \
		rm -r /tmp/aws; \
	}
	aws --version

aws-login:
	aws configure

eksctl:
	which eksctl || curl --fail --location --show-error "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(shell uname -s)_amd64.tar.gz" | tar xz -C /tmp
	which eksctl || mv /tmp/eksctl ${BINDIR}
	eksctl version
