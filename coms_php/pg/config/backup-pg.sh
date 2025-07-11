

pg_dumpall --exclude-database=root -U postgres > /data/backup/pg_dump_`date +%Y-%m-%d"_"%H_%M_%S`.sql

