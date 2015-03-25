set timing off verify off echo off feed off lines 95

column text format a80 head ''
column oc_study head 'STUDY'
column load_mark_user head 'MARKING USER'
Column Load_Flag format a25 head 'RECORD STATUS'
Column ord noprint

Break on oc_study skip 1

compute sum label 'Study Total' of count on oc_study

Spool LLI_ANALYSIS

set head off
select 'LLI ANALYSIS' Text,
       'Date: ' ||to_char(SYSDATE,'MM/DD/YYYY HH24:MI') Text from dual;

select 'Studies with Review Option "ON"' Text from dual;

SELECT 'SUMMARY INFORMATION' text from dual;


Select 'Real Users: '||to_Char(count(distinct a.load_mark_user)) Text, 20 ord
 from nci_labs a,
      nci_lab_load_ctl b
  where a.oc_study = b.oc_study
    and b.review_study = 'Y'
    and a.LOAD_MARK_USER is not null
    and a.LOAD_MARK_USER <> 'OPS$BDL'
Union 
Select 'Studies: '||to_Char(count(distinct a.oc_study)) Text, 10 ord
 from nci_labs a,
      nci_lab_load_ctl b
  where a.oc_study = b.oc_study
    and b.review_study = 'Y'
Union    
Select 'Labs Needing Reviewed: '||to_Char(count(*)) Text, 30 ord
 from nci_labs a,
      nci_lab_load_ctl b
  where a.oc_study = b.oc_study
    and b.review_study = 'Y'
    and a.load_flag = 'R'
Union
Select 'Labs Waiting to Load: '||to_Char(count(*)) Text, 35 ord
 from nci_labs a,
      nci_lab_load_ctl b
  where a.oc_study = b.oc_study
    and b.review_study = 'Y'
    and a.load_flag = 'L'
Union
Select 'Labs Loaded in Last 7 days: '||to_Char(count(*)) Text, 40 ord
 from nci_labs a,
      nci_lab_load_ctl b
  where a.oc_study = b.oc_study
    and b.review_study = 'Y'
    and a.load_date > sysdate - 7
    and a.load_flag in ('C','U')
Union    
Select 'Labs Archived or Other in Last 7 days: '||to_Char(count(*)) Text, 50 ord
 from nci_labs a,
      nci_lab_load_ctl b
  where a.oc_study = b.oc_study
    and b.review_study = 'Y'
    and a.date_modified > sysdate - 7
    and a.load_flag not in ('C','U')
Order by Ord;
    
SELECT 'DETAIL INFORMATION' text from dual;

set head on

select oc_study from nci_lab_load_ctl where review_study = 'Y'
order by oc_study;

set head off
select 'Marking User Counts for Review Studies' Text from dual;
set head on

Select a.oc_study, a.LOAD_MARK_USER, count(*) COUNT
  from nci_Labs a,
       nci_lab_load_ctl b
 where a.oc_study = b.oc_study
   and b.review_study = 'Y'
   and a.LOAD_MARK_USER is not null
group by a.oc_study, a.load_mark_user
order by a.oc_study, a.load_mark_user;

set head off
select 'ALL Status Counts for Review Studies (Life Time)' Text from dual;
set head on

Select a.oc_study, 
       decode(a.LOAD_FLAG, 'A', 'A - Archived',
                           'C', 'C - Loaded',
                           'R', 'R - Needs Review',
                           'L', 'L - Marked for Load',
                           'X', 'X - Duplicate Record',
                           'E', 'E - Error (not loaded)',
                           'W', 'W - Update to Load',
                           'U', 'U - Loaded Update',
                           'Unknown') LOAD_FLAG,
       count(*)  COUNT
  from nci_Labs a,
       nci_lab_load_ctl b
 where a.oc_study = b.oc_study
   and b.review_study = 'Y'
group by a.oc_study, a.LOAD_FLAG
order by a.oc_study, a.LOAD_FLAG;

set head off
select 'ALL Status Counts for Review Studies (Last 30 Days)' Text from dual;
set head on

Select a.oc_study, 
       decode(a.LOAD_FLAG, 'A', 'A - Archived',
                           'C', 'C - Loaded',
                           'R', 'R - Needs Review',
                           'L', 'L - Marked for Load',
                           'X', 'X - Duplicate Record',
                           'E', 'E - Error (not loaded)',
                           'W', 'W - Update to Load',
                           'U', 'U - Loaded Update',
                           'Unknown') LOAD_FLAG,
       count(*) COUNT
  from nci_Labs a,
       nci_lab_load_ctl b
 where a.oc_study = b.oc_study
   and b.review_study = 'Y'
   and a.date_modified > add_months(sysdate, -1)
group by a.oc_study, a.LOAD_FLAG
order by a.oc_study, a.LOAD_FLAG;

set head off
select 'ALL Status Counts for Review Studies (Since Last Week)' Text from dual;
set head on

Select a.oc_study, 
       decode(a.LOAD_FLAG, 'A', 'A - Archived',
                           'C', 'C - Loaded',
                           'R', 'R - Needs Review',
                           'L', 'L - Marked for Load',
                           'X', 'X - Duplicate Record',
                           'E', 'E - Error (not loaded)',
                           'W', 'W - Update to Load',
                           'U', 'U - Loaded Update',
                           'Unknown') LOAD_FLAG,
       count(*) COUNT
  from nci_Labs a,
       nci_lab_load_ctl b
 where a.oc_study = b.oc_study
   and b.review_study = 'Y'
   and a.date_modified > sysdate - 7
group by a.oc_study, a.LOAD_FLAG
order by a.oc_study, a.LOAD_FLAG
/


spool off

