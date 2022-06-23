-- Pig latin run on Hadoop cluster
-- ファイルからロードして、分割して結果を指定フォルダに格納
A = LOAD 'hdfs://localhost:8020//pig_data/emplist.txt'
USING PigStorage(',')
AS (id:int, name:chararray, age:int, address:chararray, salary:int);
SPLIT A INTO X IF age>=40, Y IF (salary > 7000);
STORE X INTO 'hdfs://localhost:8020//pig_data/pigtest01';
STORE Y INTO 'hdfs://localhost:8020//pig_data/pigtest02';
