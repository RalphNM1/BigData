from pyspark.sql import SparkSession
from pyspark import SparkContext
from pyspark.sql.functions import col, to_timestamp, to_date, hour, count, avg, date_format,dayofmonth, max, min
from pyspark.sql.types import StructType, StructField, IntegerType, FloatType, StringType
import matplotlib.pyplot as plt
import pandas as pd

get_ipython().magic(u'matplotlib inline')
if __name__ == '__main__':
    
    spark = SparkSession.builder.appName('Coches_emisiones').getOrCreate()
    sc = spark.sparkContext

    # Cargar CSV como RDD
    rdd_raw = sc.textFile('coches.csv')
    cabecera = rdd_raw.first()
    rdd_datos = rdd_raw.filter(lambda fila: fila != cabecera).map(lambda fila: fila.split(","))



    # Convertir el RDD a lista y luego a DataFrame de pandas
    columnas = ['Marca', 'Modelo', 'Precio', 'KM', 'Año', 'Tipo_de_combustible', 'CV', 'Ubicacion', 'Transmision', 'Codigo_postal', 'Comunidad_autonoma']
    datos = rdd_datos.take(10)  # Mostrar las primeras 10 filas

    df = pd.DataFrame(datos, columns=columnas)
    df