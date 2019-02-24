#!/bin/bash

#SBATCH --nodes=2                             # REQUEST 2 nodes
#SBATCH --mincpus=2                           # REQUEST a minimum of 2 CPUs per node
#SBATCH --tasks-per-node=2                    # REQUEST 2 tasks per node (matches the CPUs per node --mincpus value)
#SBATCH --mem-per-cpu=1G                      # REQUEST a minimum of 1GB RAM per CPU
#SBATCH -t00:05:00                            # SET a 5 minute time limit
#SBATCH --exclusive                           # REQUEST exclusive access to the nodes assigned

echo "T_INFO : Hello! My 2-node cluster is running on the following nodes : "

# Get the host name of each node and save it to a file to be read
scontrol show hostnames $SLURM_JOB_NODELIST > NODELIST

# delete the IPLIST file if it exists to get ready to re-make with append command
#rm IPLIST

# Read through each line of NODELIST
# Print out each read line to show all of the node names
# pass the command through ping and look for the IP address that is printed
#while read -r; do
#    nodename=("$REPLY")
#    echo $nodename
#    ping -c 1 $nodename | awk -F"[()]" '{print $2}' | head -1 >> IPLIST
#done < NODELIST

# Assign each IP address appended to the file above to a unique variable (This should be a loop in the future)
master_ip=`sed -n "1 p" NODELIST`
slave1_ip=`sed -n "2 p" NODELIST`
#slave2_ip=`sed -n "3 p" node_ipaddress.txt`
#slave3_ip=`sed -n "4 p" node_ipaddress.txt`

echo "T_INFO : And here are the associated IP addressees for each node: "
echo $master_ip
echo $slave1_ip
#echo $slave2_ip
#echo $slave3_ip

make_hdfs_site ()
{
    echo "<?xml version="'"1.0"'" encoding="'"UTF-8"'"?>                           "  > $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "<?xml-stylesheet type="'"text/xsl"'" href="'"configuration.xsl"'"?>      " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "<!--                                                                     " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "Licensed under the Apache License, Version 2.0 (the "'"License"'");      " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "you may not use this file except in compliance with the License.         " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "You may obtain a copy of the License at                                  " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "http://www.apache.org/licenses/LICENSE-2.0                               " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "Unless required by applicable law or agreed to in writing, software      " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "distributed under the License is distributed on an "'"AS IS"'" BASIS,    " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "See the License for the specific language governing permissions and      " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "limitations under the License. See accompanying LICENSE file.            " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "-->                                                                      " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "<!-- Put site-specific property overrides in this file. -->              " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "<configuration>                                                          " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    #echo "<property>                                                               " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    #echo "<name>dfs.name.dir</name>                                                " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    #echo "<value>file:~/hadoop_store/hdfs/namenode</value>                         " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    #echo "</property>                                                              " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    #echo "<property>                                                               " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    #echo "<name>dfs.data.dir</name>                                                " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    #echo "<value>file:~/hadoop_store/hdfs/datanode</value>                         " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    #echo "</property>                                                              " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
    echo "</configuration>                                                         " >> $HOME/hadoop/etc/hadoop/hdfs-site.xml
}

make_core_site ()
{
    echo "<?xml version="'"1.0"'" encoding="'"UTF-8"'"?>                           "  > $HOME/hadoop/etc/hadoop/core-site.xml
    echo "<?xml-stylesheet type="'"text/xsl"'" href="'"configuration.xsl"'"?>      " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "<!--                                                                     " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "Licensed under the Apache License, Version 2.0 (the "'"License"'");      " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "you may not use this file except in compliance with the License.         " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "You may obtain a copy of the License at                                  " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "http://www.apache.org/licenses/LICENSE-2.0                               " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "Unless required by applicable law or agreed to in writing, software      " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "distributed under the License is distributed on an "'"AS IS"'" BASIS,    " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "See the License for the specific language governing permissions and      " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "limitations under the License. See accompanying LICENSE file.            " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "-->                                                                      " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "<!-- Put site-specific property overrides in this file. -->              " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "<configuration>                                                          " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "<property>                                                               " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "<name>fs.default.name</name>                                                " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "<value>hdfs://$1:9000</value>                                            " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "</property>                                                              " >> $HOME/hadoop/etc/hadoop/core-site.xml
    echo "</configuration>                                                         " >> $HOME/hadoop/etc/hadoop/core-site.xml
}

make_mapred_site ()
{
    echo "<?xml version="'"1.0"'" encoding="'"UTF-8"'"?>                           "  > $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "<?xml-stylesheet type="'"text/xsl"'" href="'"configuration.xsl"'"?>      " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "<!--                                                                     " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "Licensed under the Apache License, Version 2.0 (the "'"License"'");      " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "you may not use this file except in compliance with the License.         " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "You may obtain a copy of the License at                                  " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "http://www.apache.org/licenses/LICENSE-2.0                               " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "Unless required by applicable law or agreed to in writing, software      " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "distributed under the License is distributed on an "'"AS IS"'" BASIS,    " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "See the License for the specific language governing permissions and      " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "limitations under the License. See accompanying LICENSE file.            " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "-->                                                                      " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "<!-- Put site-specific property overrides in this file. -->              " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "<configuration>                                                          " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "<property>                                                               " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "<name>mapreduce.framework.name</name>                                    " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "<value>yarn</value>                                                      " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "</property>                                                              " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
    echo "</configuration>                                                         " >> $HOME/hadoop/etc/hadoop/mapred-site.xml
}

make_yarn_site ()
{
    echo "<?xml version="'"1.0"'" encoding="'"UTF-8"'"?>                           "  > $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "<?xml-stylesheet type="'"text/xsl"'" href="'"configuration.xsl"'"?>      " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "<!--                                                                     " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "Licensed under the Apache License, Version 2.0 (the "'"License"'");      " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "you may not use this file except in compliance with the License.         " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "You may obtain a copy of the License at                                  " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "http://www.apache.org/licenses/LICENSE-2.0                               " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "Unless required by applicable law or agreed to in writing, software      " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "distributed under the License is distributed on an "'"AS IS"'" BASIS,    " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "See the License for the specific language governing permissions and      " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "limitations under the License. See accompanying LICENSE file.            " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "-->                                                                      " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "<!-- Put site-specific property overrides in this file. -->              " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "<configuration>                                                          " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<property>                                                               " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<name>yarn.resourcemanager.resource-tracker.address</name>               " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<value>$1:8025</value>                                                   " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "</property>                                                              " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<property>                                                               " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<name>yarn.resourcemanager.scheduler.address</name>                      " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<value>$1:8030</value>                                                   " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "</property>                                                              " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<property>                                                               " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<name>yarn.resourcemanager.address</name>                                " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<value>$1:8050</value>                                                   " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "</property>                                                              " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<property>                                                               " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<name>yarn.nodemanager.aux-services</name>                               " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<value>mapreduce_shuffle</value>                                         " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "</property>                                                              " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<property>                                                               " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>       " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<value>org.apache.hadoop.mapred.ShuffleHandler</value>                   " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "</property>                                                              " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<property>                                                               " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<name>yarn.nodemanager.disk-health-checker.min-healthy-disks</name>      " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "<value>0</value>                                                         " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    #echo "</property>                                                              " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
    echo "</configuration>                                                         " >> $HOME/hadoop/etc/hadoop/yarn-site.xml
}

make_master_file ()
{
    echo "$1"  > $HADOOP_HOME/etc/hadoop/masters
}

make_slave_file ()
{
    echo "$1"  >  $HADOOP_HOME/etc/hadoop/slaves
}

# Use IP addresses to configure files within $HADOOP_HOME/etc/hadoop/ directory on local machine
make_core_site "$master_ip"
make_hdfs_site
make_mapred_site
make_yarn_site "$master_ip"
make_master_file "$master_ip"
make_slave_file "$slave1_ip"


# If for some reason the daemons are running before we start, we want to stop them first and do some file configuration
$HADOOP_HOME/sbin/stop-all.sh


# For each node within the passed in list, we want to SSH into the machine and configure the hadoop directories
# The default location for hadoop files on nodes is within the /tmp directory.
# It seems as if the options are to either keep using the /tmp directory on each node (as the local user directory is
# common to all nodes and can't be used), or to configure the hdfs-site.xml file to point nodes at specific directories.
# Since using the /tmp directory is more straightforward, that is what is being done now (and may be improved in the future if it works)
for node in $(cat NODELIST)
do
    echo "T_INFO : executing 'rm -rf /tmp/hadoop-$USER on $node'"
    ssh $node "rm -rf /tmp/hadoop-$2"
    echo "T_INFO : executing 'mkdir /tmp/hadoop-$USER on $node'"
    ssh $node "mkdir /tmp/hadoop-$USER"
    ssh $node "chmod 755 /tmp/hadoop-$USER"
    ssh $node "date > /tmp/hadoop-$USER/SUCCESS"
    ssh $node "echo 'T_INFO : created directory /tmp/hadoop-$USER/'"
done

# Every job generates logs per node. We want to delete these every run so that we don't have to filter through the logs
rm -rf $HADOOP_HOME/logs/*

# Locally format the namenode
$HADOOP_HOME/bin/hdfs namenode -format -force

# Now we can start the daemons again
bash $HADOOP_HOME/sbin/start-dfs.sh

# Start yarn daemons as well
bash $HADOOP_HOME/sbin/start-yarn.sh

# Check the health report to make sure everything started correctly
hdfs dfsadmin -report

# Print out the running daemons

# Create directories on the hdfs node
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/twagenhals
hdfs dfs -ls /user
echo "T_INFO : User directories created."

# Copy the local hadoop config directory to a file called "input" on hdfs node
hdfs dfs -put /home/gridsan/twagenhals/hadoop/etc /user/twagenhals/input
echo "T_INFO : Hadoop config directory copies to hdfs"

# Execute the map reduce example. The input file put onto hdfs is the input and then the results are saved to output
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.0.jar grep input output 'dfs[a-z.]+'
echo "T_INFO : Mapreduce example executed"

# Get the output that was generated and copy it to the local system
hdfs dfs -get output output
echo "T_INFO : Output copied from hdfs node to local machine"

# Task completed, stopp all daemons
bash ~/hadoop/sbin/stop-all.sh

exit $?