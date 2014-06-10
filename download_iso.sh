#!/bin/bash

cd isos
wget -O CentOS.torrent http://isoredirect.centos.org/centos/6/isos/x86_64/CentOS-6.5-x86_64-bin-DVD1to2.torrent

ctorrent -s CentOS -X "mv CentOS/*DVD1.iso CentOS.iso" CentOS.torrent
