cd /home/casuser/metricbeat-8.3.3-linux-x86_64 
./metricbeat modules list
mv  metricbeat.yml  metricbeat.yml-old
cat >> metricbeat.yml  << EOL
metricbeat.modules:
- module: system
  period: 60s
  metricsets:
    - cpu             # CPU usage
    - load            # CPU load averages
    - memory          # Memory usage
    - diskio          # Disk IO usage
    - filesystem      # File system usage for each mountpoint
    - fsstat          # File system statistics
  cpu.metrics: ["percentages", "normalized_percentages"]
  enabled: true
  processors:
    - add_fields:
        target: system_info
        fields:
          category: infra_metrics
          internal_srv: 'CAS'
          project: 'Phoenix P3 CAS'
          service_id: SE001715
          enviroment: "dev"  #change this as per enviroment
          monitoring_type: 'Infra'
          Configuration Item: 'Global AWS Service' 
          service: 'Cloud Managed Infra Services (Infosys)' 
          service_offering: 'Cloud Managed Infra Services Support' 
          Application_Name: 'CAS (Cloud Application Services)'
          Tribe: 'INFRAIT Cloud Orchestration'
          Platform: 'Infrastructure IT'


- module: system
  period: 60s
  metricsets:
    - network         # Network IO
    - service
    - process
    - process_summary # high-level statistics on running processes
    - socket_summary  # count of existing TCP and UDP connections and listening ports
    - uptime          # System Uptime
  process.include_top_n:
    by_cpu: 5      # include top 5 processes by CPU
    by_memory: 5   # include top 5 processes by memory
  enabled: true
  processors:
    - add_cloud_metadata: ~
    - add_host_metadata: ~ 
    - add_fields:
        target: system_info
        fields:
          category: infra_metrics
          internal_srv: 'CAS'
          project: 'Phoenix P3 CAS'
          service_id: SE001715
          enviroment: "dev" 
          monitoring_type: 'Infra'
          Configuration Item: 'Global AWS Service'
          service: 'Cloud Managed Infra Services (Infosys)'
          service_offering: 'Cloud Managed Infra Services Support' 
          Application_Name: 'CAS (Cloud Application Services)'
          Tribe: 'INFRAIT Cloud Orchestration'
          Platform: 'Infrastructure IT'
        


# =============================== MaaPs Logstash ================================
output.logstash:
  hosts: ["10.64.110.24:5045"]
EOL
chown root metricbeat.yml
mkdir data
mkdir logs
cd /etc/systemd/system
mv metricbeat.service metricbeat.service-old
cat >> metricbeat.service << EOL
[Unit]
Description=Metricbeat service to fetch server metrics and send to elastic.
Documentation=https://www.elastic.co/products/beats/metricbeat
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/home/casuser/metricbeat-8.3.3-linux-x86_64/metricbeat --environment systemd  -c /home/casuser/metricbeat-8.3.3-linux-x86_64/metricbeat.yml --path.home /home/casuser/metricbeat-8.3.3-linux-x86_64 --path.config /home/casuser/metricbeat-8.3.3-linux-x86_64 --path.data /home/casuser/metricbeat-8.3.3-linux-x86_64/data --path.logs /home/casuser/metricbeat-8.3.3-linux-x86_64/logs
Restart=always

[Install]
WantedBy=multi-user.target
EOL
chmod 755 metricbeat.service
systemctl enable metricbeat.service
systemctl daemon-reload
systemctl start metricbeat.service


