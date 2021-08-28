Leer texto a la manera de un ser humano con la ventaja de que la máquina puede hacerlo mucho más rápido.

Librería nltk

Pasar el texto a minúsculas.

Tokenizar el texto: partir el texto en partes más pequeñas: oraciones, palabras, bigramas (dos palabras), trigramas (tres palabras), etc.

Remover los stopwords: palabras que son útiles en español pero que agregan ruido (preposiciones, pronombres). El paquete nltk cuenta con diccionarios de stopwords. También se pueden agregar stopwords. El científico de datos decide si es necesario remover stopwords.

Stemmizar el texto: remover prefijos y sufijos para llevar las palabras a una misma raíz (algoritmo snowball).
Lemmatizar el texto: lleva todas las palabras a una única raíz sin multilar la palabra manteniendo el sentido.

Utilize expresiones regulares

Después de preprocesar el texto se pueden visualizar algunos aspectos del texto:
- Diagrama de frecuencia de las palabras

De donde vienen los datos textuales

Corpus de texto: conjunto de doumentos
web scrapping: opbtener textos de paginas html

Paquete textract: extrae texto de imagenes y PDF

Data Aquisition es la habilidad más importante en Text Analytics.



Taller:
1. Sacar los datos de los sistemas de correo eléctronico (utilice la API de Google Clod y GMail)
1.1. Activar Google Cloud Platform con tarjeta de crédito.
2. Habilitar Gmail API
3. Dscargar masivamente los correos de alguna cuenta
4. Preprocese la fuente de datos
5. Genere visualizaciones: nube de palabras. De una semana específica.

# Representación de textos

Una vez preprocesado y visualizado el texto (con resumenes estadísticos, etc). Ahora el interés está en 
desarrollar modelos que "entiendad" esos textos (resumir, clasificar, etc.).

Se requiere una forma de representar esos textos. Hay dos estrategias: bolsa de palabras y representación sintáctica del texto.

## Bolsa de palabras

Se contruye una matriz de documentos-términos (MDT). Tome todos los documentos de su corpus en las filas y un listado de términos
en las columnas y en cada celda cuente el número de veces que aparece el término en el documnnto.

Para armar esta matriz, el paquete nltk tiene 

NOTA: Vuelvase amigo del paquete sklearn de Python.

La matriz de documentos términos es muy grande y nos intereseará reducir la dimensionalidad. Existe estas técnicas 
- Omitienso stopwords
- Omiitir terminos dispersos (baja frecuencia)
- Omita terminos con bajo TF-IDF

Tarea: Para la siguiente clase, estudiar la distribución delta y la de Dirichlet.

TF-IDF

TF: Term Frecuence
Esta transformación pondera cada termina en el documento; normaliza su importancia.

IDF:  
Esta transformación mide que tan importante es el documento en todo el corpus.

TF-IDF dirá que tan importante es un término. Esto nos permitirá estraer del análisis las palabras que no aportan mayor información.


