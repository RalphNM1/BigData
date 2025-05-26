#!/usr/bin/env python
# coding: utf-8

# In[17]:


from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

if __name__ == '__main__':
    spark = SparkSession.builder.appName("Analise Coches ").getOrCreate()

    esquema = StructType([
        StructField("Marca", StringType(), True),
        StructField("Modelo", StringType(), True),
        StructField("Precio", IntegerType(), True),
        StructField("KM", FloatType(), True),
        StructField("Año", IntegerType(), True),
        StructField("Tipo_de_combustible", StringType(), True),
        StructField("CV", FloatType(), True),
        StructField("Ubicacion", StringType(), True),
        StructField("Transmision", StringType(), True),
        StructField("Codigo_postal", StringType(), True),
        StructField("Comunidad_autonoma", StringType(), True),
    ])

    df = spark.read.csv("coches.csv", header=True, schema=esquema)

    df.createOrReplaceTempView("coches")
    
    print("Coches por comunidad autonoma")
    df.groupBy("Comunidad_autonoma").count().orderBy(desc("count")).show()
    
    print("Coches por transmision")
    df.groupBy("Transmision").count().show()
    
    print("Coche con más kilometraje")
    df.select("Marca","Modelo", "KM").orderBy(desc("KM")).show(1)

    print("Precio medio por marca")
    df.filter("Marca IS NOT NULL")       .groupBy("Marca")       .agg(round(avg("Precio"), 2).alias("precio_medio"))       .orderBy(desc("precio_medio"))       .show()
    
    
    


# In[ ]:




