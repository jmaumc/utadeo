* ¿Cuál es el problema que este _paper_ abarca?
Construir un modelo para recomendación implícita de top-N más eficiente que los actuales.

* ¿Por qué el problema es interesante e importante?
Porque "los sistemas de recomendación son ubicuos en tiempos modernos y han sido aplicados a servicios para recomendar items tales como música, libros y películas".

* ¿Por qué es dificil resolver el problema?
Los métodos que ya existen ofrecen una eficiencia "razonable".

* ¿Por qué el problema no se ha resuelto antes?


* ¿Qué pasa con las soluciones propuestas anteriores?

* ¿Cómo difiere la solución propuesta?
Mezcla dos modelos altamemnte eficientes: modelo de factorización de matrices y modelo basado en grafos.

* ¿Cúales son los componentes claves de la solución?
"Aproximación de la factorización de matrices probalísticas de orden superior a través de caminatas aleatorias con un factor de dacaimiento con confianza ponderada"

* ¿Cuáles son los resultados?
En general, el método propuesto por los autores es superior a los métodos _baseline_ excepto en el conjunto de datos "Amazon-Book". El método es superior a los demas bajo el criterio MAP@10.

* ¿Qué limitaciones específicas tiene la solución propuesta?
Aunque tiene mejor desempeño que los otros métodos _baseline_ con respecto a conjuntos de datos relativamente grandes como el conjunto de datos Amazon-Book, el desempeño en este tipo de conjuntos de datos sigue siendo bajo y aproximadamente equivalente a los otros métodos _baseline_. 
