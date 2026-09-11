# FINAL PROJECT DEVOPS BOOTCAMP

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

## Steps

1. **clone project ini**

2. **Apply semula & catat output baharu:**
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   terraform output
   ```

3. **Kemas kini DNS** — `web_public_ip` sudah berubah; kemas kini rekod A
   `web.<domain-anda>` dalam Cloudflare ke IP baharu.

4. **Bina & tolak semula image aplikasi**
   ```bash
   git clone https://github.com/<akaun-anda>/devops-bootcamp-fyp.git
   cd devops-bootcamp-fyp/ansible
   ansible-galaxy install -r requirements.yml
   ansible -i ~/inventory.ini fyp -m ping

   # -e @/etc/devops-fyp/secrets.yml WAJIB — tanpanya task "Log masuk ke ECR"
   # gagal dengan ralat "ecr_repository_url is undefined"
   ansible-playbook -i ~/inventory.ini site.yml -e @/etc/devops-fyp/secrets.yml
   ```

5. **SSM ke controller BAHARU** (instance ID berubah setiap kali `apply`):
   ```bash
   aws ec2 describe-instances \
     --filters "Name=private-ip-address,Values=10.0.0.135" "Name=instance-state-name,Values=running" \
     --query "Reservations[].Instances[].InstanceId" --output text

   aws ssm start-session --target <instance-id-controller-baharu>
   sudo su - ubuntu
   ```

6. **Jika `ansible`/`ansible-galaxy` tak dijumpai** — `apt` pada controller
   kadang perlukan refresh index dahulu (walaupun `user_data` dah cuba pasang
   semasa boot):
   ```bash
   sudo apt-get update
   sudo apt-get install -y ansible-core
   ```

7. **Clone, install, ping, deploy:**
   ```bash
   git clone https://github.com/<akaun-anda>/devops-bootcamp-fyp.git
   cd devops-bootcamp-fyp/ansible
   ansible-galaxy install -r requirements.yml
   ansible -i ~/inventory.ini fyp -m ping

   # -e @/etc/devops-fyp/secrets.yml WAJIB — tanpanya task "Log masuk ke ECR"
   # gagal dengan ralat "ecr_repository_url is undefined"
   ansible-playbook -i ~/inventory.ini site.yml -e @/etc/devops-fyp/secrets.yml
   ```

8. **Sahkan** (sama seperti Langkah 8 di atas):
   ```bash
   curl -I http://<web_public_ip>/
   ```
   `https://web.<domain-anda>` dan `https://monitoring.<domain-anda>` patut
   hidup semula secara automatik — route DNS proxied dan tunnel Cloudflare
   tak berubah, hanya perlu container baharu sambung semula.

9. **Sediakan semula Grafana** (data source + dashboard hilang bersama volume):
   - Log masuk `https://monitoring.<domain-anda>` — `admin` / `admin`, tukar password.
   - Connections → Data sources → Add data source → Prometheus →
     URL `http://prometheus:9090` → Save & test.
   - Dashboards → New → Import → ID `1860` (Node Exporter Full) → pilih data
     source Prometheus → Import.
