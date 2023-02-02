#!/bin/bash


mkdir -p /opt/security_incidents

echo "
Enable file_output in /etc/falco/falco.yaml

file_output:
  enabled: true
  keep_alive: false
  filename: /opt/security_incidents/alerts.log
"

echo "##########################################################"

cat <<EOF > /etc/falco/falco_rules.local.yaml

 - rule: Write below binary dir
   desc: an attempt to write to any file below a set of binary directories
   condition: >
     bin_dir and evt.dir = < and open_write
     and not package_mgmt_procs
     and not exe_running_docker_save
     and not python_running_get_pip
     and not python_running_ms_oms
     and not user_known_write_below_binary_dir_activities
   output: >
     File below a known binary directory opened for writing (user=%user.name file_updated=%fd.name command=%proc.cmdline)
   priority: CRITICAL
   tags: [filesystem, mitre_persistence]
   
EOF

# kill -1 $(pidof falco)

