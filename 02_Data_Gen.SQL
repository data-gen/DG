--------------------------------------------------------------------------------
--  CUSTOMER DATA 생성 
--------------------------------------------------------------------------------

SET SERVEROUTPUT OFF
rem SET SERVEROUTPUT ON SIZE UNLIMITED
rem SPOOL MAKE_DATA_CUSTOMER.LOG


 DECLARE
    V_SQL              VARCHAR2(1000);
    V_MAX_RECORD     NUMBER(10) := 6000000;  -- 고객 데이터 생성 건수 지정
    R_CUSTOMER       CUSTOMER%ROWTYPE;
    
    TYPE  T_NESTTBL  IS TABLE OF  VARCHAR2(20) ;  -- Nested Table

    V_SURNAME          T_NESTTBL;       -- 고객 이름 첫 번째 글자(성)
    V_MIDNAME         T_NESTTBL;-- 고객 이름 가운데 글자
    V_LASTNAME        T_NESTTBL;-- 고객 이름 마지막 글자
    V_PRE_MOBILE      T_NESTTBL;-- 고객 전화 번호 국번
    V_MID_MOBILE      T_NESTTBL; -- 고객 전화 번호
    V_EMAIL_SP         T_NESTTBL;        -- E-Mail 서비스 공급자
    V_EMAIL_PRE       T_NESTTBL;-- E-Mail 주소
BEGIN
    -- 성: 78개   , 가운데 글자: 100개  , 이름 마지막 글자: 100개 
    -- 78만명( 78 * 100 * 100) 고객 이름 랜덤하게 생성
V_SURNAME  :=  T_NESTTBL('김','이','박','조','최','정','손','강','신','임','장','윤','권','전','유','오','한','서','황','안','송','홍','양','고','문','배','백','류','허','노','남','심','주','구','하','곽','성','차','민','진','우','엄','나','지','변','방','원','채','천','공','현','함','여','석','도','염','리','추','소','기','설','마','선','길','위','연','왕','반','명','금','옥','표','라','맹','육','제','탁','모');
    V_MIDNAME  :=  T_NESTTBL('기','길','가','고','광','건','경','근','구','국','규','군','도','동','나','남','노','다','도','동','덕','대','리','라','미','민','명','무','문','보','배','범','병','상','서','석','선','성','설','시','신','세','소','송','수','숙','순','승','시','상','이','아','익','인','일','여','연','영','예','오','우','원','유','윤','은','용','재','정','주','준','철','춘','충','종','지','진','태','찬','창','채','하','학','호','훈','한','화','황','희','혁','현','형','해','혜','효','성','명','청','두','래','관','기','필','율','차','초','교');
    V_LASTNAME :=  T_NESTTBL('근','구','규','국','관','광','권','경','결','규','균','권','나','남','동','덕','라','란','리','림','령','미','민','명','빈','범','배','상','서','석','선','섭','식','신','심','실','상','성','세','수','숙','순','승','이','익','일','아','안','연','열','영','오','옥','우','욱','운','은','용','원','유','율','윤','은','인','애','완','재','정','종','주','준','자','지','진','철','찬','창','태','택','표','혁','현','헌','형','해','혜','호','홍','화','하','한','환','후','휘','훈','혁','현','형','희','박','주','삼','중','기','백','솔');

-- 고객 전번 랜덤 생성   
V_PRE_MOBILE := T_NESTTBL('010','010','010','010','010','010','010','011','016','019');
V_MID_MOBILE := T_NESTTBL('2','3','4','5','6','7','8','9');
    
-- 고객 이메일 번호 랜덤 생성
V_EMAIL_SP  := 
T_NESTTBL('gmail.com','gmail.com','naver.com','naver.com','hotmail.com','yahoo.com','kopo.ac.kr','daum.net','korea.com','dreamwiz.com','aol.com','cau.ac.kr','samsung.com','lg.com','sk.com');
    
-- 2008년 기준 빈번히 사용되는 영단어 50개 와 랜덤4개 문자로 임의의 이메일 주소 생성   
V_EMAIL_PRE  :=
T_NESTTBL('the','of','and','a','to','in','is','you','that','it','he','was','for','on','are','as','with','his','they','i','at','be','this','have','from','or','one','had','by','word','but','not','what','all','were','we','when','your','can','said','there','use','an','each','which','she','do','how','their','if'); 

FOR I IN 1..V_MAX_RECORD
    LOOP
    BEGIN
 SELECT LOWER(DBMS_RANDOM.STRING('a',10))  AS PWD,
        V_SURNAME(CEIL(DBMS_RANDOM.VALUE(0.1,77.99)))||
        V_MIDNAME(CEIL(DBMS_RANDOM.VALUE(0.1,99.99)))||
         V_LASTNAME(CEIL(DBMS_RANDOM.VALUE(0.1,99.99)))  AS  NAME,
DECODE(CEIL(DBMS_RANDOM.VALUE(0.1,13.9999)),1,7369,2,7499,3,7521,4,7566,5,7654,6,7698,7,7782,8,7499,9,7844,10,7900,11,7902,12,7934,13,7788,14,7876) AS  ACCOUNT_MGR,
 -- PRESIDENT 7839는 ACCOUNT_MGR에서 제외하고 7499가 대신한다 
CEIL(DBMS_RANDOM.VALUE(0.1,52119.99))     AS ZIPCODE,
 V_PRE_MOBILE(CEIL(DBMS_RANDOM.VALUE(0.1,9.99)))||
 V_MID_MOBILE(CEIL(DBMS_RANDOM.VALUE(0.1,7.99)))||
   TO_CHAR(CEIL(DBMS_RANDOM.VALUE(0,998.99)),'fm000')||
   TO_CHAR(CEIL(DBMS_RANDOM.VALUE(0,9998.99)),'fm0000')     AS MOBILE_NO,
 ROUND(CEIL(DBMS_RANDOM.VALUE(0,4999.99)),2)                 AS CREDIT_LIMIT
,V_EMAIL_PRE(CEIL(DBMS_RANDOM.VALUE(0.1,49.99)))||LOWER(DBMS_RANDOM.STRING('a',4))||'@'|| V_EMAIL_SP(CEIL(DBMS_RANDOM.VALUE(0.1,14.99)))              AS EMAIL,
SYSDATE - ( CEIL(DBMS_RANDOM.VALUE(20,58.99)) * 365)       AS  BIRTH_DT,       
                                                   --고객나이  20살  <=    <= 59살
SYSDATE – CEIL(DBMS_RANDOM.VALUE(0,3649.99))  AS ENROLL_DT,   -- 가입일     10년전 <=   <= 오늘
SYSDATE – DBMS_RANDOM.VALUE(0,3649.99)                    AS  ENROLL_DT, 
DECODE(CEIL(DBMS_RANDOM.VALUE(0.1,1.99)),1,'M',2,'F')         AS  GENDER
              INTO      R_CUSTOMER.PWD,
                         R_CUSTOMER.NAME,
                         R_CUSTOMER.ACCOUNT_MGR ,
                         R_CUSTOMER.ZIPCODE,
                         R_CUSTOMER.MOBILE_NO,
                         R_CUSTOMER.CREDIT_LIMIT,
                         R_CUSTOMER.EMAIL,
                         R_CUSTOMER.BIRTH_DT,
                         R_CUSTOMER.ENROLL_DT,
                         R_CUSTOMER.GENDER
             FROM   DUAL;

 -- 이메일 주소를  ID로 사용 하는 경우  R_CUSTOMER.ID := R_CUSTOMER.EMAIL; 
 -- 일련번호를 고객 ID로 사용한다
 R_CUSTOMER.ID := TO_CHAR(I,'fm00000000');
    
 -- 고객 주소 임의 생성중  아파트가 나오는 경우 동,호를 랜덤 생성
 --                        빌딩이 나오는 경우      호를 랜덤 생성
 --                        기타 주소 인 경우     번지를 랜덤 생성             
  SELECT ZIPCODE,  SIDO||' '||GUGUN||' '||DONG as address1,
         RI||' '||CASE 
        WHEN INSTR(RI,'아파트') > 0  THEN 
              ROUND(DBMS_RANDOM.VALUE(100,500))||'동 '||ROUND(DBMS_RANDOM.VALUE(101,999))||'호' 
        WHEN INSTR(RI,'빌딩') > 0    THEN 
              ROUND(DBMS_RANDOM.VALUE(101,999))||'호' 
        ELSE ROUND(DBMS_RANDOM.VALUE(101,999))||' 번지' END as address2 
  INTO  R_CUSTOMER.ZIPCODE , R_CUSTOMER.ADDRESS1, R_CUSTOMER.ADDRESS2
 FROM  ZIPCODE
 WHERE SEQ = TO_NUMBER(R_CUSTOMER.ZIPCODE);
              
              
INSERT INTO CUSTOMER(ID,PWD,NAME,ZIPCODE,ADDRESS1,ADDRESS2,MOBILE_NO,
          CREDIT_LIMIT,EMAIL,ACCOUNT_MGR,BIRTH_DT,ENROLL_DT,GENDER)
VALUES(R_CUSTOMER.ID,R_CUSTOMER.PWD,R_CUSTOMER.NAME,R_CUSTOMER.
       ZIPCODE,R_CUSTOMER.ADDRESS1,R_CUSTOMER.ADDRESS2,
R_CUSTOMER.MOBILE_NO,R_CUSTOMER.CREDIT_LIMIT,R_CUSTOMER.EMAIL,
       R_CUSTOMER.ACCOUNT_MGR,R_CUSTOMER.BIRTH_DT,R_CUSTOMER.ENROLL_DT,
       R_CUSTOMER.GENDER);
             
IF  MOD(I,10000) = 0  THEN--  10,000건 단위 COMMIT 
   COMMIT;
END IF;
       
 EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('SQL ERRM =>'||SQLERRM);
   
                DBMS_OUTPUT.PUT_LINE(R_CUSTOMER.NAME);    
                DBMS_OUTPUT.PUT_LINE(R_CUSTOMER.ACCOUNT_MGR);    
                DBMS_OUTPUT.PUT_LINE(R_CUSTOMER.MOBILE_NO);    
                DBMS_OUTPUT.PUT_LINE(R_CUSTOMER.EMAIL);    
                DBMS_OUTPUT.PUT_LINE(R_CUSTOMER.BIRTH_DT);    
                DBMS_OUTPUT.PUT_LINE(R_CUSTOMER.ENROLL_DT);    
                DBMS_OUTPUT.PUT_LINE(R_CUSTOMER.GENDER);             
   END;
   
   END LOOP;
   
   COMMIT;
   
END;
/

SELECT COUNT(*) FROM CUSTOMER;

REM 통계정보 수집
ANALYZE TABLE CUSTOMER  COMPUTE STATISTICS FOR TABLE FOR ALL INDEXES FOR ALL INDEXED COLUMNS;

/*
EXECUTE  DBMS_STATS.GATHER_TABLE_STATS(tabname=>'CUSTOMER', 
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
            method_opt =>' FOR ALL COLUMNS SIZE AUTO ', cascade=>TRUE);
                    
EXECUTE DBMS_STATS.GATHER_TABLE_STATS(tabname=>'CUSTOMER', 
            estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
            method_opt =>' FOR  COLUMNS (id, email )  SIZE  AUTO', 
            cascade=>TRUE);
*/
