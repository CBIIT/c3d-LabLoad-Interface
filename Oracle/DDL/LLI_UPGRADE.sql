-- LLI - UPGRADE

set echo on verify on

spool LLI_UPGRADE

/* 
   Alter table commands 
*/


/*
   Create Index Commands
*/


/*
   Create View Commands
*/

/*
   Packages / Procedures / Functions
*/

@make_number.plsql

/*
   Public Synonyms
*/

CREATE PUBLIC SYNONYM MAKE_NUMBER FOR OPS$BDL.MAKE_NUMBER;

/* 
   Roles
*/


/*
   Object Privileges
*/

Grant execute on OPS$BDL.MAKE_NUMBER to PUBLIC;

Grant execute on OPS$BDL.MAKE_NUMBER to LABLOADER;

Grant execute on OPS$BDL.MAKE_NUMBER to LABLOADER_ADMIN;

Grant execute on OPS$BDL.MAKE_NUMBER to LABLOADER_REVIEW;


spool off

