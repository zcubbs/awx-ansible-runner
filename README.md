# AWX Bootsrap Runner

Update AWX configuration (templates, invertories, etc...) from git using a Kubernetes Job.

## Usage

### Create a sercret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ansible-secrets
type: Opaque
data:
  GIT_REPO_URL: <base64-encoded-git-url>
  GIT_REPO_USERNAME: <base64-encoded-git-username>
  GIT_REPO_PASSWORD: <base64-encoded-git-password>
  ANSIBLE_VAULT_KEY: <base64-encoded-vault-key>
  CONTROLLER_HOST: <base64-encoded-controller-host>
  CONTROLLER_USERNAME: <base64-encoded-username>
  CONTROLLER_PASSWORD: <base64-encoded-password>
  CONTROLLER_VERIFY_SSL: <base64-encoded-verify-ssl>
```

### Create the Job Manifest:
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: ansible-job
spec:
  template:
    spec:
      containers:
        - name: ansible
          image: ghcr.io/zcubbs/awx-ansible-runner:latest
          imagePullPolicy: Always
          env:
            - name: GIT_REPO_URL
              valueFrom:
                secretKeyRef:
                  name: ansible-secrets
                  key: GIT_REPO_URL
            - name: GIT_REPO_USERNAME
              valueFrom:
                secretKeyRef:
                  name: ansible-secrets
                  key: GIT_REPO_USERNAME
            - name: GIT_REPO_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: ansible-secrets
                  key: GIT_REPO_PASSWORD
            - name: ANSIBLE_VAULT_KEY
              valueFrom:
                secretKeyRef:
                  name: ansible-secrets
                  key: ANSIBLE_VAULT_KEY
            - name: CONTROLLER_HOST
              valueFrom:
                secretKeyRef:
                  name: ansible-secrets
                  key: CONTROLLER_HOST
            - name: CONTROLLER_USERNAME
              valueFrom:
                secretKeyRef:
                  name: ansible-secrets
                  key: CONTROLLER_USERNAME
            - name: CONTROLLER_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: ansible-secrets
                  key: CONTROLLER_PASSWORD
            - name: CONTROLLER_VERIFY_SSL
              valueFrom:
                secretKeyRef:
                  name: ansible-secrets
                  key: CONTROLLER_VERIFY_SSL
            - name: PLAYBOOK_NAME
              value: "my-playbook.yaml"
      restartPolicy: Never
  backoffLimit: 0
```

### Run the job:
```bash
kubectl -n awx apply -f my-secret.yaml
kubectl -n awx apply -f my-job.yaml
```
