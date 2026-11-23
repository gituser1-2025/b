
LAB 1

STEP 1: Create the input text file

gedit word.txt

Enter and save:

Hello world
Hello Hadoop.

STEP 2: Create the mapper file

gedit mapper.py

Enter and save:

#!/usr/bin/python
import sys

# reading entire line from STDIN (standard input)
for line in sys.stdin:
   word = line.strip().split()
   for word in words:
       print("%s\t%s" % (word, 1))

STEP 3: Run and print the mapper output

cat word.txt | python mapper.py

Output shown in the lab:

Hello world
Hello Hadoop

Mapper-: Hello -1, world -1, Hello -1, Hadoop -1

STEP 4: Create the reducer file

gedit reducer.py

Enter and save:

#!/usr/bin/env python

import sys

counts = {}

for line in sys.stdin:
    word, count = line.strip().split('\t')
    counts[word] = counts.get(word, 0) + int(count)

for word, count in counts.items():
   print "%s\t%s" % (word, count)

STEP 5: Run mapper + sort + reducer and print the result

cat word.txt | python mapper.py | sort | python reducer.py

Output shown in the lab:

Reducer-: Hello -2, world -1, Hadoop -1

STEP 6: Create directory in HDFS

hdfs dfs -mkdir prg1

STEP 7: Upload input file to HDFS

hdfs dfs -put /home/cloudera/word.txt /user/cloudera/prg1

STEP 8: List HDFS directory

hdfs dfs -ls /user/cloudera/prg1

STEP 9: Give permission to mapper and reducer

chmod 777 mapper.py reducer.py

STEP 10: Run Hadoop Streaming

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar
   -input /user/cloudera/prg1/word.txt
   -output /user/cloudera/prg1/output
   -mapper /home/cloudera/mapper.py
   -reducer /home/cloudera/reducer.py

STEP 11: Print the output stored in HDFS

hdfs dfs -cat /user/cloudera/prg1/output/part-00000


LAB 2

STEP 1: Create the input file

gedit titanic.txt

Enter and save:

Owen,male,22
Hannah,female,38
Laina,female,26
Lily,female,35
Allen,male,35
Jack,male,28
Emma,female,31
Thomas,male,42
Sophia,female,24
William,male,30

STEP 2: Create the mapper file

gedit mapper2.py

Enter and save:

#!/usr/bin/env python
import sys
import csv

reader = csv.reader(sys.stdin)

for line in reader:
   # line[1] is gender, line[2] is age
   if len(line) > 2:
        print('%s,%s' % (line[1], line[2]))

STEP 3: Run and print mapper output

cat titanic.txt | python mapper2.py

Output shown in the lab:

male,22
male,35
female,38
female,26
female,35
male,28
female,31
male,42
female,24
male,30

STEP 4: Create the reducer file

gedit reducer2.py

Enter and save:

#!/usr/bin/env python

import sys

data = {}

for line in sys.stdin:
    gender, age = line.strip().split(',')

   if gender not in data:
         data[gender] = [0, 0]

      data[gender][0] += float(age)
      data[gender][1] += 1

for gender, values in data.items():
   average = values[0] / values[1]
   print("%s = %s" % (gender, average))

STEP 5: Run mapper + sort + reducer

cat titanic.txt | python mapper2.py | sort | python reducer2.py

Output shown in the lab:

For male:
   male = 31.4
For female:
   Female = 30.8

STEP 6: Create HDFS directory

hdfs dfs -mkdir prg2

STEP 7: Upload Titanic file to HDFS

hdfs dfs -put /home/cloudera/titanic.txt /user/cloudera/prg2

STEP 8: List HDFS directory

hdfs dfs -ls /user/cloudera/prg2

STEP 9: Give permission to mapper and reducer

chmod 777 mapper2.py reducer2.py

STEP 10: Run Hadoop Streaming

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar
   -input /user/cloudera/prg2/titanic.txt
   -output /user/cloudera/prg2/output
   -mapper /home/cloudera/mapper2.py
   -reducer /home/cloudera/reducer2.py

STEP 11: Print HDFS output

hdfs dfs -cat /user/cloudera/prg2/output/part-00000

STEP 12: If output already exists, delete the output folder

hdfs dfs -rm -r /user/cloudera/prg2/output


LAB 3

STEP 1: Create the input file

gedit input.txt

Enter and save:

a,0,0,1
a,0,1,2
a,1,0,3
a,1,1,4
b,0,0,5
b,0,1,6
b,1,0,7
b,1,1,8

STEP 2: Create the mapper file

gedit mapper3.py

Enter and save:

#!/usr/bin/env python
import sys

for line in sys.stdin:
   p = line.strip().split(‘ , ’)
   if len(p) == 4:
            print "%s\t%s" % (p[0].lower(), ','.join(p))

STEP 3: Run and print mapper output

cat input.txt | python mapper3.py

Output shown in the lab:

a a,0,0,1
a a,0,1,2
a a,1,0,3
a a,1,1,4
b b,0,0,5
b b,0,1,6
b b,1,0,7
b b,1,1,8

STEP 4: Create the reducer file

gedit reducer3.py

Enter and save:

#!/usr/bin/env python
import sys

a, b = {}, {}

for line in sys.stdin:
   try:
         tag, val = line.strip().split('\t')
             p = val.split(',')
             i, j, v = int(p[1]), int(p[2]), int(p[3])

             if tag == 'a':
             a[i, j] = v
         elif tag == 'b':
             b[i, j] = v
   except:
             continue

for i in range(2):
   for j in range(2):
        s = sum(a.get((i, k), 0) * b.get((k, j), 0) for k in range(2))
            print "(%d,%d)\t%d" % (i, j, s)

STEP 5: Run mapper + sort + reducer

cat input.txt | python mapper3.py | sort | python reducer3.py

STEP 6: Create HDFS directory

hdfs dfs -mkdir prg7

STEP 7: List HDFS

hdfs dfs -ls

STEP 8: Upload input file to HDFS

hdfs dfs -put /home/cloudera/input.txt /user/cloudera/prg7

STEP 9: List the HDFS directory

hdfs dfs -ls /user/cloudera/prg7

STEP 10: Give permissions

chmod 777 mapper3.py reducer3.py

STEP 11: Run Hadoop Streaming

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar
   -input /user/cloudera/prg7/input.txt
   -output /user/cloudera/prg7/output
   -mapper /home/cloudera/mapper3.py
   -reducer /home/cloudera/reducer3.py

STEP 12: Print output from HDFS

hdfs dfs -cat /user/cloudera/prg7/output/part-00000


LAB 4

STEP 1: Create the input dataset

gedit word1.txt

Enter and save:

1,pooja,R, 20,
2 ,sam,Thomas,25
3,priya,S, 20
4,pavan,Rao, 20

STEP 2: Start services

Start hue, hdfs, yarn.

STEP 3: Open Pig local mode

pig –x local;

STEP 4: Enter the Pig statements

A = LOAD 'word1.txt' USING PigStorage(',')
  AS (id:int, first_name:chararray, last_name:chararray, age:int);

//-- get first letter of first_name
B = FOREACH A GENERATE UPPER(SUBSTRING(first_name, 0, 1)) AS
first_letter;

C = GROUP B BY first_letter;
D = FOREACH C GENERATE group AS first_letter, COUNT(B) AS count;
E = ORDER D BY count DESC;
F = LIMIT E 1;
DUMP F;

STEP 5: Output shown in the lab

P
S
P
P

(S,1)
(P,3)

(P,3)
(S,1)

Final output:
(P,3)


LAB 5

STEP 1: Create the Python file

gedit rdd.py

STEP 2: Enter and save the code

from pyspark import SparkContext
from pyspark.sql import SQLContext

# Start Spark
sc = SparkContext()
sql = SQLContext(sc)

# Create RDD
rdd = sc.parallelize([
   (1, "AIML", 69),
   (2, "CS", 72),
   (3, "ECE", 99)
])

# Convert RDD to DataFrame
df = sql.createDataFrame(rdd, ["No", "Dept", "No_of_students"])

# Show output on screen
df.show()

sc.stop()

STEP 3: Run the program

spark-submit rdd.py


LAB 6

STEP 1: Create a directory

hdfs dfs -mkdir lab4

STEP 2: List the contents of a directory

hdfs dfs -ls /user/cloudera/lab4

STEP 3: Copy a file from local file system to Hadoop file system

hdfs dfs -put /home/cloudera/titanic.txt /user/cloudera/lab4

For uploading a file from linux to Hadoop use put command

STEP 4: List the HDFS directory

hdfs dfs –ls /user/cloudera/lab4

STEP 5: See contents of the file

hdfs dfs -cat /user/cloudera/lab4/titanic.txt

STEP 6: Remove a directory and files present inside it in HDFS

hdfs dfs -rm -r /user/cloudera/lab4


LAB 7

STEP 1: Create the Python file

gedit retail.py

STEP 2: Enter and save the code

from pyspark import SparkContext
from pyspark.sql import SQLContext

# Step 1: Start Spark
sc = SparkContext()
sql = SQLContext(sc)

# Step 2: Create data
data = [
  ("Laptop", "Electronics", 50000),
  ("Phone", "Electronics", 30000),
  ("Rice", "Grocery", 5000),
  ("Oil", "Grocery", 2000),
  ("Chair", "Furniture", 4000),
  ("Table", "Furniture", 8000)
]

# Step 3: Create DataFrame
columns = ["Product", "Category", "Sales"]
df = sql.createDataFrame(data, columns)

# Step 4: Display all products
print("All Products:")
df.show()

# Step 5: Filter sales above 5000
print("Products with sales above 5000:")
df.filter(df.Sales > 5000).show()

# Step 6: Total sales by category
print("Total Sales by Category:")
df.groupBy("Category").sum("Sales").show()

# Step 7: Find the highest-selling product
print("Highest-Selling Product:")
df.agg({"Sales": "max"}).show()

# Step 8: Sort sales from highest to lowest
print("Products sorted by Sales:")
df.orderBy(df.Sales.desc()).show()

# Step 9: Stop Spark
sc.stop()

STEP 3: Run the program

spark-submit retail.py


LAB 8

STEP 1: Create the input file

gedit products.txt

Enter and save:

Laptop,Electronics,50000
Mobile,Electronics,20000
Rice,Grocery,5000
Oil,Grocery,2000
Chair,Furniture,4000
Table,Furniture,8000

STEP 2: Start services

Start hdfs, yarn, hue.

STEP 3: Open Pig local mode

pig –x local;

STEP 4: Enter the Pig statements

-- Step 1: Load the product data
products = LOAD 'products.txt’ USING PigStorage(',’)
AS (product:chararray, category:chararray, sales:int);


-- Step 2: Display all records
DUMP products;


--Step 3: Group products by category
grouped = GROUP products BY category;

-- Step 4: Count products in each category
result = FOREACH grouped GENERATE group, COUNT(products);

DUMP result;


-- Step 5: Filter Electronics products
electronics = FILTER products BY category == 'Electronics';

DUMP electronics;


LAB 9

STEP 1: Create the Python file

gedit students.py

STEP 2: Enter and save the code

from pyspark import SparkContext
from pyspark.sql import SQLContext

# Start Spark
sc = SparkContext()
sql = SQLContext(sc)

# Create DataFrame
data = [
(1, "AIML", 69),
(2, "CS", 72),
(3, "ECE", 99)
]

# Step 3: Create DataFrame
columns = ["No", "Dept", "No_of_students"]
df = sql.createDataFrame(data, columns)

# Display DataFrame
df.show()

# Save DataFrame
df.rdd.saveAsTextFile("/user/cloudera/output_students")

# Stop Spark
sc.stop()

STEP 3: Run the program

spark-submit students.py

STEP 4: List the output directory in HDFS

hdfs dfs -ls /user/cloudera/output_students

STEP 5: Print the output file

hdfs dfs -cat /user/cloudera/output_students/part-00000


