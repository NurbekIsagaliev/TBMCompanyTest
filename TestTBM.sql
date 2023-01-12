CREATE TABLE sku
(
  ID          NUMBER,
  NAME        VARCHAR2(200) not null,
  CONSTRAINT pk_sku
  PRIMARY KEY
  (id)
);
/


CREATE TABLE orders
(
  ID          NUMBER,
  N_DOC       NUMBER,
  DATE_DOC    DATE,
  AMOUNT      NUMBER,
  DISCOUNT    NUMBER,
  CONSTRAINT pk_orders
  PRIMARY KEY
  (id),
  CONSTRAINT orders_discount CHECK(DISCOUNT>=0  and DISCOUNT<=100)
);
/


CREATE TABLE orders_detail
(
  ID          NUMBER,
  ID_ORDER    NUMBER not null,
  ID_SKU      NUMBER not null,
  PRICE       NUMBER,
  QTY         NUMBER,
  STR_SUM     NUMBER,
  IDX         NUMBER,
  CONSTRAINT pk_orders_detail
  PRIMARY KEY
  (id),
  CONSTRAINT fk_orders_detail_sku 
  FOREIGN KEY (id_sku) 
  REFERENCES sku (id)
  ENABLE VALIDATE,
  CONSTRAINT fk_orders_detail_order 
  FOREIGN KEY (id_order) 
  REFERENCES orders (id)
  ENABLE VALIDATE 
);
/

create  sequence sku_id
increment  by 1
start  with 1
maxvalue 1000
nocache
nocycle;
/

CREATE OR REPLACE TRIGGER "sku_id" 
BEFORE INSERT
ON sku
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
BEGIN
   SELECT sku_id.NEXTVAL INTO :NEW.ID FROM dual;
   null;
END "sku_id";
/  

insert into sku(NAME) values('product1');
insert into sku(NAME) values('product2');
insert into sku(NAME) values('product3');
insert into sku(NAME) values('product4');
/

create  sequence orders_id
increment  by 1
start  with 1
maxvalue 1000
nocache
nocycle;
/



CREATE OR REPLACE TRIGGER "orders_id" 
BEFORE INSERT
ON orders
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
BEGIN
   SELECT orders_id.NEXTVAL INTO :NEW.ID FROM dual;
   null;
END "orders_id";
/  


insert into orders(N_DOC,DATE_DOC,DISCOUNT) values(1,TO_DATE('2023/01/01', 'yyyy/mm/dd'),50);
insert into orders(N_DOC,DATE_DOC,DISCOUNT) values(2,TO_DATE('2023/01/02', 'yyyy/mm/dd'),40);
insert into orders(N_DOC,DATE_DOC,DISCOUNT) values(3,TO_DATE('2023/01/03', 'yyyy/mm/dd'),0);
insert into orders(N_DOC,DATE_DOC,DISCOUNT) values(4,TO_DATE('2023/01/04', 'yyyy/mm/dd'),10);
/


create  sequence orders_detail_id
increment  by 1
start  with 1
maxvalue 1000
nocache
nocycle;
/

CREATE OR REPLACE TRIGGER "orders_detail_id" 
BEFORE INSERT
ON orders_detail
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
  dis orders.DISCOUNT%type;

BEGIN
   SELECT orders_detail_id.NEXTVAL INTO :NEW.ID FROM dual;
   null;
   select DISCOUNT into dis  from orders o where o.ID=:NEW.ID_ORDER;
   null;
   update orders set AMOUNT = (:new.PRICE * :new.QTY) where ID = :NEW.ID_ORDER;
   if :new.PRICE is not null and :new.QTY is not null then
 :new.STR_SUM := (:new.PRICE * :new.QTY)*(1-(dis/100));

end if;

END "orders_detail_id";
/ 

CREATE INDEX orders_detail_idx
ON orders_detail(idx);
/


create  sequence orders_detail_idx
increment  by 1
start  with 1
maxvalue 1000
nocache
nocycle;
/


CREATE OR REPLACE TRIGGER "orders_detail_idx" 
BEFORE INSERT
ON orders_detail
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
BEGIN
   SELECT orders_detail_idx.NEXTVAL INTO :NEW.IDX FROM dual;
   null;
END "orders_detail_idx";
/  



insert into orders_detail(ID_ORDER,ID_SKU,PRICE,QTY) values(1,1,100,10);
insert into orders_detail(ID_ORDER,ID_SKU,PRICE,QTY) values(2,2,200,20);
insert into orders_detail(ID_ORDER,ID_SKU,PRICE,QTY) values(3,3,300,30);
insert into orders_detail(ID_ORDER,ID_SKU,PRICE,QTY) values(4,4,300,40);
/


select * from orders_detail;
/

select * from orders;
/







