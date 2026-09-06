# app

Dockerfile multi-stage yang klon [Infratify/ship](https://github.com/Infratify/ship)
(microsite Vite + Three.js), bina dengan `npm run build`, dan sajikan hasil
`dist/` melalui nginx pada port 80. Tiada source app disimpan dalam repo ini —
`git clone` berlaku semasa `docker build`.

## Bina dan tolak ke ECR

EC2 (`t3.micro`) berjalan atas amd64 — jika bina di Mac Apple Silicon, `--platform
linux/amd64` WAJIB supaya image tidak gagal jalan dengan `exec format error`.

```bash
aws ecr get-login-password --region ap-southeast-1 \
  | docker login --username AWS --password-stdin <account-id>.dkr.ecr.ap-southeast-1.amazonaws.com

docker build --platform linux/amd64 -t devops-bootcamp/final-project-arifin app/

docker tag devops-bootcamp/final-project-arifin:latest \
  <account-id>.dkr.ecr.ap-southeast-1.amazonaws.com/devops-bootcamp/final-project-arifin:latest

docker push <account-id>.dkr.ecr.ap-southeast-1.amazonaws.com/devops-bootcamp/final-project-arifin:latest
```

`<account-id>.dkr.ecr...` = output `ecr_repository_url` selepas `terraform apply`.
Selepas image baru ditolak, jalankan semula `playbook-web.yaml` dari controller
untuk tarik dan naikkan versi terkini.
