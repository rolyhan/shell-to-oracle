#! /usr/bin/sh
####### ora connect ########
ora_conn="user/pwd@oraclesid"
##month day#######
dts=`sqlplus -silent ${ora_conn}  <<END
set pagesize 0 feedback off verify off heading off echo off
select to_number(to_char(last_day(trunc(add_months(last_day(sysdate),-2)+1)),'DD')) from dual;
exit;
END`
dte=0
while (( $dts > $dte ))
do
dtc=`sqlplus -silent ${ora_conn} <<END
set pagesize 0 feedback off verify off heading off echo off
select to_char(trunc(add_months(last_day(sysdate),-2)+1)+$dte,'yyyymmdd') from dual;
exit;
END`
var=$dtc
cd /
var1=`ls E*_$dtc*|wc -l`
let dte=dte+1
func_execpro()
{
sqlplus -slient ${ora_conn}  <<END
set pagesize 0 feedback off verify off heading off echo off
exec P_TONGJI_INSERT($var,$var1);
exit;
END
}
func_execpro
done
