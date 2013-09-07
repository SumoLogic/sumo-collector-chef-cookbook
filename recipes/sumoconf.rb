#
# Author:: Ben Newton (<ben@sumologic.com>)
# Cookbook Name:: sumologic-collector
# Recipe:: Configure sumo.conf for unattended installs and activation
#
# Copyright 2013, Sumo Logic
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# The template sumo.conf file includes variables to customize it (username, password, etc.)
#
# Sumo Logic Help Links
# https://service.sumologic.com/ui/help/Default.htm#Unattended_Installation_from_a_Linux_Script_using_the_Collector_Management_API.htm
# https://service.sumologic.com/ui/help/Default.htm#Using_sumo.conf.htm
# https://service.sumologic.com/ui/help/Default.htm#JSON_Source_Configuration.htm

if node['sumologic']['conf_template'].nil?
  conf_source = 'sumo.conf.erb'
else
  conf_source = node['sumologic']['conf_template']
end

credentials = {}

if !node[:sumologic][:credentials].nil?
  creds = node[:sumologic][:credentials]
  
  if !creds[:secret_file].nil?
    secret = Chef::EncryptedDataBagItem.load_secret(creds[:secret_file]) 
    edbag = Chef::EncryptedDataBagItem.load(creds[:bag_name], creds[:item_name], secret)
    credentials[:email],credentials[:password] = edbag[:email.to_s], edbag[:password.to_s] # Chef::EncryptedDataBagItem 10.28 doesn't work with symbols
  else
    bag = data_bag_item(creds[:bag_name], creds[:item_name])
    credentials[:email],credentials[:password] = bag[:email.to_s], bag[:password.to_s] # Chef::DataBagItem 10.28 doesn't work with symbols
  end
else
 credentials[:email],credentials[:password] = node[:sumologic][:userID], node[:sumologic][:password] 
end

template '/etc/sumo.conf' do
  cookbook node['sumologic']['conf_config_cookbook']
  source conf_source 
  owner 'root'
  group 'root'
  mode 0644
  variables({
    :email  => credentials[:email],
    :password => credentials[:password],
  })
end


