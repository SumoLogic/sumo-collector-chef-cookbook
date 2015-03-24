#
# Author:: Ben Newton (<ben@sumologic.com>)
# Cookbook Name:: sumologic-collector
# Recipe:: Install, Register, and Configure Collector
#
# Copyright 2013, Sumo Logic
#
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

#
# Sumo Logic Help Links
# https://service.sumologic.com/ui/help/Default.htm#Unattended_Installation_from_a_Linux_Script_using_the_Collector_Management_API.htm
# https://service.sumologic.com/ui/help/Default.htm#Using_sumo.conf.htm
# https://service.sumologic.com/ui/help/Default.htm#JSON_Source_Configuration.htm
#

if File.exists? node['sumologic']['installDir']
    Chef::Log.info "Sumo Logic Collector found."
	# If collector is in sync source mode, just comment these lines to update the sources
    include_recipe 'sumologic-collector::sumoconf'
	# use the recipe sumojsondir if your source configurations are in a directory 
    include_recipe 'sumologic-collector::sumojsondir'
	# use the recipe sumojson if your source configurations are in a single json file
    #include_recipe 'sumologic-collector::sumojson'
    include_recipe 'sumologic-collector::restart'
else
    Chef::Log.info "Installing Sumo Logic Collector..."
    include_recipe 'sumologic-collector::sumoconf'
	# use the recipe sumojson if your source configurations are in a single json file
    #include_recipe 'sumologic-collector::sumojson'
	# use the recipe sumojsondir if your source configurations are in a directory 
    include_recipe 'sumologic-collector::sumojsondir'
    include_recipe 'sumologic-collector::install'
    #include_recipe 'sumologic-collector::cleanup'
end
