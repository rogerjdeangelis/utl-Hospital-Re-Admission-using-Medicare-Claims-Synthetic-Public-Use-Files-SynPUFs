%let pgm=rdm_010adm;
%let pgm=utl-Hospital-Re-Admission-using-Medicare-Claims-Synthetic-Public-Use-Files-SynPUFs;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* Hospital Re-Admission using Medicare Claims Synthetic Public Use Files SynPUFs;                                        */
/*                                                                                                                        */
/* github                                                                                                                 */
/* https://tinyurl.com/mrxrp3ew                                                                                           */
/* https://github.com/rogerjdeangelis/utl-Hospital-Re-Admission-using-Medicare-Claims-Synthetic-Public-Use-Files-SynPUFs  */
/*                                                                                                                        */
/* SAS Table                                                                                                              */
/* Download https://1drv.ms/u/s!AovFHZtMPA-7gQqtAdkmkX6eJ9wp?e=YQEnw3                                                     */
/*                                                                                                                        */
/* A re-Admission is defined as a second admsission date within 30 days for the same patient and claim.                   */
/* There other more complex definiions of re-admissions.                                                                  */
/*                                       _  _                                                                             */
/*  _ __  _ __ ___   ___ ___  ___ ___   / _| | _____      __                                                              */
/* | `_ \| `__/ _ \ / __/ _ \/ __/ __| | |_| |/ _ \ \ /\ / /                                                              */
/* | |_) | | | (_) | (_|  __/\__ \__ \ |  _| | (_) \ V  V /                                                               *
/* | .__/|_|  \___/ \___\___||___/___/ |_| |_|\___/ \_/\_/                                                                */
/* |_|                                                                                                                    */
/*                                                                                                                        */
/*  1. Download https://1drv.ms/u/s!AovFHZtMPA-7gQqtAdkmkX6eJ9wp?e=YQEnw3                                                 */
/*  2. Unzip to sas table                                                                                                 */
/*  3. A re-Admission is defined as a second admsission date within 30 days for the same patient and claim.               */
/*     These can be transfers.                                                                                            */
/*                                 _                                                                                      */
/*   _____  ____ _ _ __ ___  _ __ | | ___                                                                                 */
/*  / _ \ \/ / _` | `_ ` _ \| `_ \| |/ _ \                                                                                */
/* |  __/>  < (_| | | | | | | |_) | |  __/                                                                                */
/*  \___/_/\_\__,_|_| |_| |_| .__/|_|\___|                                                                                */
/*                          |_|                                                                                           */
/*  proc sql;                                                                                                             */
/*    create                                                                                                              */
/*       table rdm_010admTst as                                                                                           */
/*    select                                                                                                              */
/*        desynpuf_id                                                                                                     */
/*       ,clm_id                                                                                                          */
/*       ,clm_admsn_dt                                                                                                    */
/*       ,nch_bene_dschrg_dt                                                                                              */
/*       ,clm_from_dt                                                                                                     */
/*       ,clm_thru_dt                                                                                                     */
/*    from                                                                                                                */
/*       rdm.rad_010inpatient                                                                                             */
/*    where                                                                                                               */
/*       year(CLM_ADMSN_DT ) = 2010 and desynpuf_id = '02F982E89F95C3BD'                                                  */
/*    order                                                                                                               */
/*       by  desynpuf_id                                                                                                  */
/*          ,clm_id                                                                                                       */
/*          ,nch_bene_dschrg_dt                                                                                           */
/*  ;quit;                                                                                                                */
/*                                                                                                                        */
/*                                                                                                                        */
/* Up to 40 obs WORK.RDM_010ADMTST total obs=2 18SEP2022:08:44:34                                                         */
/*                                                                                                                        */
/*                                                 CLM_                                                                   */
/* Obs      DESYNPUF_ID           CLM_ID         ADMSN_DT                                                                 */
/*                                                                                                                        */
/*  1     02F982E89F95C3BD    391981153970289      18426    ==> first admission                                           */
/*  2     02F982E89F95C3BD    391981153970289      18437    ==> second admission                                          */
/*                                                                                                                        */
/*                                                 18437 - 18426 = 11 days or 12 if counting fist and last day            */
/*                                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Hospital Re-Admission less than or equal to 30 days                                                                   */
/*                                                                                                                        */
/*                                      Admission    Re-Admit    Days to                                                  */
/*  Patient           Claim                  Date        Date   Re-Admit                                                  */
/*                                                                                                                        */
/*  017362FE3870A2DE  542401180893912  2009-08-05  2009-09-02         28                                                  */
/*  01DD1E414DDD5248  241441127035032  2009-01-18  2009-02-13         26                                                  */
/*  0257DC7D188D323B  293281115473989  2008-05-07  2008-06-03         27                                                  */
/*  02F982E89F95C3BD  391981153970289  2010-06-13  2010-06-24         11                                                  */
/*  03133DE177AC774B  444201142389374  2010-01-21  2010-02-16         26                                                  */
/*  0337E8ED258DF34B  489791192411243  2008-10-27  2008-11-23         27                                                  */
/*  03CE3907FD592F80  143531188563124  2009-04-13  2009-05-09         26                                                  */
/*  04A95F1F09FE631D  143761188533872  2008-09-23  2008-10-23         30                                                  */
/*  04C46D2435325628  594441169332272  2009-02-20  2009-03-17         25                                                  */
/*  04F6BA21B44C69B3  489321192439646  2010-10-26  2010-11-16         21                                                  */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

Download and unzip
https://1drv.ms/u/s!AovFHZtMPA-7gQqtAdkmkX6eJ9wp?e=YQEnw3

./rad_010inpatient.sas7bdat

/**************************************************************************************************************************/
/*                                                                                                                        */
/* Middle Observation(666411) of ./rad_010inpatient - Total Obs 1,332,822                                                 */
/*                                                                                                                        */
/*  -- CHARACTER --               TYPE       VALUE               LABEL                                                    */
/*                                                                                                                        */
/* YEAR_CLM_THRU_DT                 C4       2010                YEAR_CLM_THRU_DT                                         */
/* SAMPLE_NO                        C2       11                  SAMPLE_NO                                                */
/* DESYNPUF_ID                      C16      00A9C880AC42130C    DESYNPUF_ID                                              */
/* CLM_ID                           C15      692171107797194     CLM_ID                                                   */
/* PRVDR_NUM                        C6       0100GU              PRVDR_NUM                                                */
/* AT_PHYSN_NPI                     C10      4878214599          AT_PHYSN_NPI                                             */
/* OP_PHYSN_NPI                     C10      1655193032          OP_PHYSN_NPI                                             */
/* OT_PHYSN_NPI                     C10                          OT_PHYSN_NPI                                             */
/* ADMTNG_ICD9_DGNS_CD              C5       71536               ADMTNG_ICD9_DGNS_CD                                      */
/* CLM_DRG_CD                       C3       508                 CLM_DRG_CD                                               */
/* ...                                                                                                                    */
/* ICD9_DGNS_CD_1                   C5       71536               ICD9_DGNS_CD_1                                           */
/* ICD9_DGNS_CD_10                  C5                           ICD9_DGNS_CD_10                                          */
/* ...                                                                                                                    */
/* ICD9_PRCDR_CD_1                  C4       8151                ICD9_PRCDR_CD_1                                          */
/* ICD9_PRCDR_CD_6                  C5                           ICD9_PRCDR_CD_6                                          */
/* ...                                                                                                                    */
/* HCPCS_CD_1                       C1                           HCPCS_CD_1                                               */
/* ....                                                                                                                   */
/* HCPCS_CD_45                      C1                           HCPCS_CD_45                                              */
/* TOTOBS                           C16      1,332,822           TOTOBS                                                   */
/*                                                                                                                        */
/*  -- NUMERIC --                                                                                                         */
/*                                                                                                                        */
/* SEGMENT                          N3       1                   SEGMENT                                                  */
/* CLM_FROM_DT                      N4       18379               CLM_FROM_DT                                              */
/* CLM_THRU_DT                      N4       18382               CLM_THRU_DT                                              */
/* CLM_PMT_AMT                      N3       20000               CLM_PMT_AMT                                              */
/* NCH_PRMRY_PYR_CLM_PD_AMT         N4       0                   NCH_PRMRY_PYR_CLM_PD_AMT                                 */
/* CLM_ADMSN_DT                     N4       18379               CLM_ADMSN_DT                                             */
/* CLM_PASS_THRU_PER_DIEM_AMT       N3       0                   CLM_PASS_THRU_PER_DIEM_AMT                               */
/* NCH_BENE_IP_DDCTBL_AMT           N3       1100                NCH_BENE_IP_DDCTBL_AMT                                   */
/* NCH_BENE_PTA_COINSRNC_LBLTY_AM   N3       0                   NCH_BENE_PTA_COINSRNC_LBLTY_AM                           */
/* NCH_BENE_BLOOD_DDCTBL_LBLTY_AM   N3       0                   NCH_BENE_BLOOD_DDCTBL_LBLTY_AM                           */
/* CLM_UTLZTN_DAY_CNT               N3       3                   CLM_UTLZTN_DAY_CNT                                       */
/* NCH_BENE_DSCHRG_DT               N4       18382               NCH_BENE_DSCHRG_DT                                       */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

libname rdm "d:/rdm";

* lets identify discharges theat are within 30 days with the same claimid;

proc sql;
  *reset inobs=100000;
  create
     table rdm_010admRed as
  select
     l.desynpuf_id
    ,l.clm_id
    ,l.clm_admsn_dt  as admDte
    ,r.clm_admsn_dt  as re_admDte
    ,r.clm_admsn_dt - l.clm_admsn_dt    as difAdmRe_Adm

  from
    rdm.rad_010inpatient as l, rdm.rad_010inpatient  as r
  where
        l.clm_id = r.clm_id
    and l.desynpuf_id = r.desynpuf_id
    and r.clm_admsn_dt - l.clm_admsn_dt le 30
    and r.clm_admsn_dt > l.clm_admsn_dt
  order
    by  l.desynpuf_id
       ,l.clm_id
       ,l.clm_admsn_dt
;quit;

options nolabel;
proc report data=rdm_010admred(obs=10)  nowd missing split='#';
column  desynpuf_id clm_id admdte re_admdte difadmre_adm;
define  desynpuf_id    / display 'Patient'          format= $16.      width=16 spacing=2  left ;
define  clm_id         / display 'Claim'            format= $15.      width=15 spacing=2  left ;
define  admdte         / display 'Admission#Date'   format= yymmdd10. width=10 spacing=2 right ;
define  re_admdte      / display 'Re-Admit#Date'    format= yymmdd10. width=10 spacing=2 right ;
define  difadmre_adm   / display 'Days to#Re-Admit' format= best9.    width=9  spacing=2 right ;
run;quit;

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

NOTE: Libref RDM was successfully assigned as follows:
      Engine:        V9
      Physical Name: d:\rdm
1223  * lets identify discharges theat are within 30 days with the same claimid;
1224  proc sql;
1225    *reset inobs=100000;
1226    create
1227       table rdm_010admRed as
1228    select
1229       l.desynpuf_id
1230      ,l.clm_id
1231      ,l.clm_admsn_dt  as admDte
1232      ,r.clm_admsn_dt  as re_admDte
1233      ,r.clm_admsn_dt - l.clm_admsn_dt    as difAdmRe_Adm
1234    from
1235      rdm.rad_010inpatient as l, rdm.rad_010inpatient  as r
1236    where
1237          l.clm_id = r.clm_id
1238      and l.desynpuf_id = r.desynpuf_id
1239      and r.clm_admsn_dt - l.clm_admsn_dt le 30
1240      and r.clm_admsn_dt > l.clm_admsn_dt
1241    order
1242      by  l.desynpuf_id
1243         ,l.clm_id
1244         ,l.clm_admsn_dt
1245  ;
NOTE: SAS threaded sort was used.
NOTE: Table WORK.RDM_010ADMRED created, with 760 rows and 5 columns.

1245!  quit;
NOTE: PROCEDURE SQL used (Total process time):
      real time           3.12 seconds
      user cpu time       2.70 seconds
      system cpu time     0.50 seconds
      memory              112175.15k
      OS Memory           129108.00k
      Timestamp           09/18/2022 09:03:42 AM
      Step Count                        331  Switch Count  1


1246  options nolabel;
1247  proc report data=rdm_010admred(obs=10)  nowd missing split='#';
1248  column  desynpuf_id clm_id admdte re_admdte difadmre_adm;
1249  define  desynpuf_id    / display 'Patient'          format= $16.      width=16 spacing=2  left ;
1250  define  clm_id         / display 'Claim'            format= $15.      width=15 spacing=2  left ;
1251  define  admdte         / display 'Admission#Date'   format= yymmdd10. width=10 spacing=2 right ;
1252  define  re_admdte      / display 'Re-Admit#Date'    format= yymmdd10. width=10 spacing=2 right ;
1253  define  difadmre_adm   / display 'Days to#Re-Admit' format= best9.    width=9  spacing=2 right ;
1254  run;

NOTE: Multiple concurrent threads will be used to summarize data.
NOTE: There were 10 observations read from the data set WORK.RDM_010ADMRED.
NOTE: PROCEDURE REPORT used (Total process time):
      real time           0.11 seconds
      user cpu time       0.04 seconds
      system cpu time     0.09 seconds
      memory              7482.65k
      OS Memory           24588.00k
      Timestamp           09/18/2022 09:03:42 AM
      Step Count                        332  Switch Count  0

1254!     quit;


/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
