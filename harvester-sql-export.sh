#!/usr/bin/bash

sqlite3 /root/stash.sqlite ".headers on" ".mode columns" ".output client-harvester-out.txt" "select * from results;"
