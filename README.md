Description
===========
Install and configure Solr with additional Zookeeper support

Requirments
-----------

Attributes
----------

Usage
-----
If you want enable Zookeeper support then `node['solr']['zookeeper']['host']` should be set to zookeeper hosts IP.

- `node['solr']['collection']` must be represented as array ["collection1","collection2"] in this case listed collections will be created.
- `node['solr']['collection']` represented as array ["uri://path"] will download **zip** or **tar.gz** and unpack previosly prepaired collection

**Please note:** archived collection must contain only collection folders *(collection1, collection2)* and *solr.xml* collections configuration file 
