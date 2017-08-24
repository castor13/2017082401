select a.createyear,a.createmonth,count(a.createmonth) 
  from scm_salbill_hdr      a,
       scm_salbill_dtl      b,
       scm_lot_list         e,
       pub_clients          c,
       pub_waredict         d,
       pub_clients_invtitle f,
       pub_dept             g,
       pub_emp              o,
       scm_salbill_hdr      h,
       pub_store_master     m,
       (select * from pub_waredict_kind where type = '1000') n,
       (select * from pub_waredict_kind where type = '1040') isspec,
       ( select * from pub_waredict_kind where type = '1020') form
 where a.id = b.id(+)
   and a.goodid = d.goodid
   and a.cstid = m.cstid(+)
   and a.sendaddrid = m.storeid(+)
   and a.cstid = c.cstid
   and b.goodid = e.goodid(+)
   and b.lotid = e.lotid(+)
   and a.invid = f.id
   and a.saledeptid = g.deptid
   and a.sellerid = o.empid
   and a.relateid = h.id(+)
   and a.STOPFLAG = '00'
   and a.invoiceno is null
   and a.OPfin = '00'
   and a.FLOWID in ('1010', '1050', '1030','1040')
   and d.isdrug = n.kindid(+)
   and d.spdrug   = isspec.kindid(+)
   and d.compid   = isspec.compid(+)
   and d.form = form.kindid(+)
   and (
        (
       a.invtype = '10' and (
       (a.opscm = '60' and (a.flowid = '1010' or a.flowid = '1040')) or
       (a.opscm = '10' and a.flowid = '1050' ) or
       (a.opscm = '60' and a.flowid = '1030' )
                             )
        )

       or
       (
       a.invtype = '00' and (
       (a.opscm = '60' and  (a.flowid = '1010' or a.flowid = '1040')) or
       (a.opscm = '10' and a.flowid = '1050'  and h.invoiceno is not null ) or
       ((a.opscm = '60' and a.flowid = '1030' and a.SUMVALUE>0) or
       (a.opscm = '60' and a.flowid = '1030' and a.SUMVALUE<0  and h.invoiceno is not NULL AND h.saledeptid <> 207))
                           )
        )
       or
       (
       a.invtype = '00' and (
       (a.opscm = '60' and  (a.flowid = '1010' or a.flowid = '1040')) or
       (a.opscm = '10' and a.flowid = '1050'  and h.invoiceno is not null ) or
       ((a.opscm = '60' and a.flowid = '1030' and a.SUMVALUE>0) or
       (a.opscm = '60' and a.flowid = '1030' and a.SUMVALUE<0  and h.invoiceno is not NULL AND h.saledeptid = 207 AND C.Iscommercial = '30'))
                           )
        )
       or
       (
       a.invtype = '00' and (
       (a.opscm = '60' and  (a.flowid = '1010' or a.flowid = '1040')) or
       (a.opscm = '10' and a.flowid = '1050'  ) or
       ((a.opscm = '60' and a.flowid = '1030' and a.SUMVALUE>0) or
       (a.opscm = '60' and a.flowid = '1030' and a.SUMVALUE<0  AND h.saledeptid = 207 AND  nvl(C.Iscommercial,' ') <> '30'))
                           )
        )
       )

   and a.createdate <= to_date('2016/12/31','yyyy-mm-dd')
   group by a.createyear,a.createmonth
   order by a.createyear,a.createmonth
   --and a.createdate>=to_date('2013/01/01','yyyy-mm-dd')
;
