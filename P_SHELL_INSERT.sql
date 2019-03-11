CREATE OR REPLACE PROCEDURE P_SHELL_INSERT(
    i_check_date         in  varchar2                 
   ,i_error_num          in  varchar2                 
)

AS


    -- =========================== declare var ===========================

    v_errmsg              varchar2(4000);
    v_last_yearmonth      varchar(6);
    v_intcount            int;
    
    o_outcode             varchar2(500);
    o_outmsg              varchar2(500);
    

BEGIN

    -- =========================== var ===========================
        -- curmonth -1
      v_last_yearmonth := to_char(add_months(sysdate, -1),'YYYYMM');
    
   

    -- ===========================  business logic===========================
 -- todo begin
      SELECT COUNT(*) INTO v_intcount FROM USER_ALL_TABLES WHERE UPPER(TABLE_NAME)=('ERROR_ORDER_'||v_last_yearmonth);
     if  v_intcount = 0  then 
              -- create table
          execute immediate '
          create table ERROR_ORDER_'||v_last_yearmonth||'(
           check_date        varchar2(50)
          ,error_num         varchar2(50)
          )
          '
          ;
    end if;
   
    -- delete data
    execute immediate '
    delete from ERROR_ORDER_'||v_last_yearmonth||' where check_date = '||i_check_date||'';
    commit;
    -- insert table
    execute immediate '
    insert into ERROR_ORDER_'||v_last_yearmonth||'(
                                                   check_date
                                                  ,error_num
                                                 )values(
                                                  '||i_check_date||'
                                                 ,'||i_error_num||'
                                                 )'
                                               ;
     commit;

    -- todo end


  -- =========================== result message ===========================
        o_outcode := 0;
        o_outmsg :=  '≤Â»Î≥…π¶';


  -- =========================== error message ===========================
  EXCEPTION
    WHEN OTHERS THEN
       --roll
        -- rollback;

        -- result error
        o_outcode := -1;
        o_outmsg := 'faild°£errcode£∫'||SQLCODE ||'errmsg£∫'||SQLERRM;


  

END;
