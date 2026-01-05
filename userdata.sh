#!/bin/bash
dnf update -y
dnf install -y nginx
systemctl enable nginx
cat >/usr/share/nginx/html/index.html <<EOF
<h1>Terraform Production Architecture</h1>
<p>Deployed via ALB + Auto Scaling in private subnets.</p>
EOF
systemctl start nginx
