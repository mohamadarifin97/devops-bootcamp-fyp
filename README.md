# devops-bootcamp-fyp

Final project DevOps Bootcamp — VPC AWS, tiga server (web / Ansible controller /
monitoring), aplikasi disajikan sebagai container dari ECR, stack pemantauan
Prometheus + Grafana, dan dua subdomain Cloudflare untuk akses awam.

- **URL aplikasi:** https://web.sendiri.asia
- **URL monitoring:** https://monitoring.sendiri.asia
- **URL repo:** https://github.com/mohamadarifin97/devops-bootcamp-fyp

## Struktur projek

```
app/         Dockerfile multi-stage (klon Infratify/ship, bina, sajikan via nginx)
terraform/   VPC, subnet, security group, EC2, ECR, S3 backend
ansible/     Playbook dijalankan DARI controller (bukan local machine)
README.md
```
