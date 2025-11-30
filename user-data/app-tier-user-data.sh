#!/bin/bash
mkdir -p /var/www/html

cat << 'EOF' > /var/www/html/index.html
<html>
  <head>
    <title>Project 3 – 3-Tier App</title>
  </head>
  <body>
    <h1>Project 3 – App Tier</h1>
    <p>This page is served from an EC2 instance in a private subnet.</p>
    <p>VPC: project3-vpc<br>
       Tier: App<br>
       Status: Running</p>
  </body>
</html>
EOF

cd /var/www/html
nohup python3 -m http.server 80 &
