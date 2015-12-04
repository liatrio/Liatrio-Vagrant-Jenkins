#
# Cookbook Name:: liatrio
# Attributes:: default
#
# Author: Victor Piousbox <piousbox@gmail.com>
#
# Copyright 2015, Liatrio.
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

default[:home][:centos][:packages]   = %w( wget curl git emacs iptables-services )
default[:home][:ubuntu][:packages]   = %w( wget curl git emacs )
default[:home][:sleep_interval]      = 20
default[:home][:open_ports]          = %w( 
  80  81 82 83 84 85
  8080 8081 8082 8083 8084 8085 8086 8087 8088 8089 8090
  3000 3001 3002 3003 3004 3005 3006 3007 3008 3009 3010
)

default['home'].tap do |home|
  #
  # The path to the +java+ bin on disk. This attribute is intelligently
  # calculated by assuming some sane defaults from community Java cookbooks:
  #
  #   - node['java']['java_home']
  #   - node['java']['home']
  #   - ENV['JAVA_HOME']
  #
  # These home's are then intelligently joined with +/bin/java+ for the full
  # path to the Java binary. If no +$JAVA_HOME+ is detected, +'java'+ is used
  # and it is assumed that the correct java binary exists in the +$PATH+.
  #
  # You can override this attribute by setting the full path manually:
  #
  #   node.set['jenkins']['java'] = '/my/custom/path/to/java6'
  #
  # Setting this value to +nil+ will break the Internet.
  #
  home['java'] = if node['java'] && node['java']['java_home']
                      File.join(node['java']['java_home'], 'bin', 'java')
                    elsif node['java'] && node['java']['home']
                      File.join(node['java']['home'], 'bin', 'java')
                    elsif ENV['JAVA_HOME']
                      File.join(ENV['JAVA_HOME'], 'bin', 'java')
                    else
                      'java'
                    end
end






