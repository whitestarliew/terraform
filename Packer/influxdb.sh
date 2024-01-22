#!/bin/bash

# Download InfluxDB package
curl -LO https://dl.influxdata.com/influxdb/releases/influxdb2-2.7.4-1.x86_64.rpm

# Install InfluxDB
sudo yum install -y influxdb2-2.7.4-1.x86_64.rpm

# Create configuration directory
sudo mkdir -p /etc/influxdb2/config.d

# Create InfluxDB configuration file
cat << EOF > /etc/influxdb2/config.d/influxdb.conf
[data]
  dir = "/var/lib/influxdb2"

[cluster]
  enabled = false

[org]
  name = "MyOrg"
  active = true

[bucket]
  name = "MyBucket"
  organization = "MyOrg"
  retention_rules = [
    "RetentionPolicy1",
    "RetentionPolicy2"
  ]

[retention_policy]
  name = "RetentionPolicy1"
  min_retention = "7d"
  max_retention = "30d"

[retention_policy]
  name = "RetentionPolicy2"
  min_retention = "30d"
  max_retention = "1y"

# Add any additional configuration here

EOF

# Change file permissions
sudo chmod +x /etc/influxdb2/config.d/influxdb.conf

# Enable and start InfluxDB
sudo systemctl enable influxdb
sudo systemctl start influxdb

# Verify service status
sudo systemctl status influxdb

# (Optional) Create InfluxDB user and grant admin privileges
# (Replace "your_username" and "your_password" with your desired credentials)
influx -username token -password $INFLUX_TOKEN -organization MyOrg \
  create user your_username with password 'your_password' AND admin

# Exit with success code
exit 0
