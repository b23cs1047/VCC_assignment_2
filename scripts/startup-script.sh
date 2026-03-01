#! /bin/bash

# Update system
sudo apt update -y

# Install Nginx
sudo apt install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Fetch metadata from GCP
HOSTNAME=$(hostname)
INTERNAL_IP=$(hostname -I | awk '{print $1}')
DATE=$(date)

INSTANCE_ID=$(curl -H "Metadata-Flavor: Google" \
http://metadata.google.internal/computeMetadata/v1/instance/id)

ZONE=$(curl -H "Metadata-Flavor: Google" \
http://metadata.google.internal/computeMetadata/v1/instance/zone | awk -F/ '{print $NF}')

PROJECT_ID=$(curl -H "Metadata-Flavor: Google" \
http://metadata.google.internal/computeMetadata/v1/project/project-id)

# Create dynamic web page
sudo bash -c "cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
<title>GCP Auto Scaling Demo</title>
<meta http-equiv='refresh' content='5'>
<style>
body {
    font-family: Arial, sans-serif;
    background: linear-gradient(to right, #0f172a, #1e293b);
    color: white;
    text-align: center;
    padding-top: 40px;
}
.card {
    background: #111827;
    padding: 30px;
    border-radius: 12px;
    display: inline-block;
    box-shadow: 0px 0px 15px rgba(0,0,0,0.6);
}
h1 { color: #38bdf8; }
</style>
</head>

<body>
<div class='card'>
<h1>🚀 GCP Auto-Scaling Instance Active</h1>

<p><b>Hostname:</b> $HOSTNAME</p>
<p><b>Internal IP:</b> $INTERNAL_IP</p>
<p><b>Instance ID:</b> $INSTANCE_ID</p>
<p><b>Zone:</b> $ZONE</p>
<p><b>Project ID:</b> $PROJECT_ID</p>
<p><b>Instance Created At:</b> $DATE</p>

<hr>

<p>✅ Managed Instance Group Enabled</p>
<p>✅ CPU-Based Auto Scaling Configured (60%)</p>
<p>✅ Firewall Rules Applied (Allow 80/22 | Deny 8080)</p>
<p>✅ IAM Role-Based Access Control Implemented</p>

</div>
</body>
</html>
EOF"
