Description
===========
Install and configure Solr with additional Zookeeper support

[![Install](https://raw.github.com/qubell-bazaar/component-skeleton/master/img/install.png)](https://staging.dev.qubell.com/applications/upload?metadataUrl=https://github.com/loky9000/component-solr-dev/raw/master/meta.yml)

Attributes
----------

Configurations
--------------
[![Build Status](https://travis-ci.org/loky9000/component-solr-dev.png?branch=master)](https://travis-ci.org/loky9000/component-solr-dev)

 - Solr 4.x (latest), Amazon Linux (us-east-1/ami-1ba18d72), AWS EC2 m1.small, ec2-user
 - Solr 4.x (latest), CentOS 6.4 (us-east-1/ami-eb6b0182), AWS EC2 m1.small, root
     NB:  Non stable  work on Centos (Will be fixed in the next version) 
 - Solr 4.x (latest), Ubuntu 12.04 (us-east-1/ami-d0f89fb9), AWS EC2 m1.small, ubuntu
 - Solr 4.x (latest), Ubuntu 10.04 (us-east-1/ami-0fac7566), AWS EC2 m1.small, ubuntu

Pre-requisites
--------------
 - Configured Cloud Account a in chosen environment
 - Either installed Chef on target compute OR launch under root
 - Internet access from target compute:
  - MySQL distribution: ** (CentOS), ** (Ubuntu)
  - S3 bucket with Chef recipes: ** (TBD)
  - If Chef is not installed: ** (TBD)

Implementation notes
--------------------
 - Installation is based on Chef recipes from http://community.opscode.com/cookbooks/mysql


Usage
-----
If you want enable Zookeeper support then `node['solr']['zookeeper']['host']` should be set to zookeeper hosts IP.

- `node['solr']['collection']` must be represented as array ["collection1","collection2"] in this case listed collections will be created.
- `node['solr']['collection']` represented as array ["uri://path"] will download **zip** or **tar.gz** and unpack previosly prepaired collection

**Please note:** archived collection must contain only collection folders *(collection1, collection2)* and *solr.xml* collections configuration file 
