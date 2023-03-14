README PARTE LISP

La sintassi delle stringhe JSON
La sintassi JSON è definita nel sito https://www.json.org.
Dalla grammatica data, un oggetto JSON può essere scomposto 
ricorsivamente nelle seguenti parti:
1. Object
2. Array
3. Value
4. String
5. Number
Potete evitare di riconoscere caratteri Unicode.
Esempi
L’oggetto vuoto:
{}
L’array vuoto:
[]
Un oggetto con due “items”:
{
"nome" : "Arthur",
"cognome" : "Dent"
}
2
Un oggetto complesso, contenente un sotto-oggetto, che a sua volta
contiene un array di numeri (notare che, in generale, gli array non 
devono necessariamente avere tutti gli elementi dello stesso tipo)
{
 "modello" : "SuperBook 1234",
 "anno di produzione" : 2014,
 "processore" : {
 		 "produttore" : "EsseTi",
		 "velocità di funzionamento (GHz)" : [1, 2, 4, 8]
 	       }
}

Un esempio tratto da Wikipedia (una possibile voce di menu)
{
 "type": "menu",
 "value": "File",
 "items": [
 	    {"value": "New", "action": "CreateNewDoc"},
 	    {"value": "Open", "action": "OpenDoc"},
 	    {"value": "Close", "action": "CloseDoc"}
 	  ]
}


Indicazioni e requisiti
Dovete costruire un parser per le stringhe JSON che abbiamo descritto. La stringa in input va
analizzata ricorsivamente per comporre una struttura adeguata a memorizzarne le componenti. Si
cerchi di costruire un parser guidato dalla struttura ricorsiva del testo in input. Ad esempio, un
eventuale array (e la sua composizione interna in elements) va individuato dopo l’individuazione
del member del quale fa parte, e il meccanismo di ricerca non deve ripartire dalla stringa iniziale ma
bensì dal risultato della ricerca del member stesso.
In altre parole, approcci del tipo “ora cerco la posizione del ‘:’ e poi prendo la sottostringa…”,
non sono il modo migliore di affrontare in problema. Anzi: quasi sicuramente porteranno ad
un programma estremamente complicato, poco funzionante e quindi… insufficiente.

Spiegazione Funzioni:

#|------------------------------------------------------------------|#
#|	             jsonparse(JSONString, Object).	            |#
#|------------------------------------------------------------------|#
#|    Accetta in ingresso una stringa e produce una struttura       |#
#|    simile a quella illustrata per la realizzazione Prolog.       |#
#|------------------------------------------------------------------|#


#|------------------------------------------------------------------|#
#|	           jsonaccess(JSONObj Fields Result). 	            |#
#|------------------------------------------------------------------|#
#|	Accetta un oggetto JSON (rappresentato in Common Lisp, così |#
#|  come prodotto dalla funzione jsonparse) e una serie di “campi”, |#
#|  recupera l’oggetto corrispondente. Un campo rappresentato da    |#
#|  Pos (con Pos un numero maggiore o uguale a 0) rappresenta un    |#
#|  indice di un array JSON.                                        |#
#|------------------------------------------------------------------|#

#|------------------------------------------------------------------|#
#|	    Funzioni ausiliarie per verificare il tipo 	            |#
#|------------------------------------------------------------------|#
#|	Servono per verificare se l'input è un determinato tipo	    |#
#|	di variabile:                                               |#
#|	- Numero						    |#
#|	- Intero						    |#
#|	- Numero con Decimali					    |#
#|	- Singolo Apice						    |#
#|	- Doppio Apice						    |#
#|	- Stringa						    |#
#|	- Array						    	    |#
#|	- Simbolo						    |#
#|	- Coppia						    |#
#|	- Membro						    |#
#|	- Oggetto						    |#
#|	- Elemento						    |#
#|------------------------------------------------------------------|#

#|------------------------------------------------------------------|#
#|	                    analyzer/1		                    |#
#|------------------------------------------------------------------|#
#|	Nel caso l'input fosse null, restituiamo l'input.           |#
#|	Nel caso l'input fosse un atomo restituiamo la lista con    |#
#|	elemento input.					            |#
	Nel caso finale facciamo la chiamata ricorsiva.             |#
#|------------------------------------------------------------------|#

#|------------------------------------------------------------------|#
#|	                    formatfixer/1	                    |#
#|------------------------------------------------------------------|#
#|	Analizza la lista in input e ne corregge il formato per     |#
#|	renderla accettabile dalle funzioni.		            |#
#|------------------------------------------------------------------|#

#|------------------------------------------------------------------|#
#|	                    formatanalyzer/1	                    |#
#|------------------------------------------------------------------|#
#|	Analizza la lista per vedere se ha bisogno di correzioni    |#
#|------------------------------------------------------------------|#

#|------------------------------------------------------------------|#
#|	                    jsonread(Filename) 	                    |#
#|------------------------------------------------------------------|#
#|	Apre il file filename ritorna un oggetto JSON               |#
#|  (o genera un errore). Se filename non è accessibile la funzione |#
#|  genera un errore.                                               |#
#|------------------------------------------------------------------|#


#|------------------------------------------------------------------|#
#|	                    jsondump(JSON FileName) 	            |#
#|------------------------------------------------------------------|#
#|	Scrive l’oggetto JSON sul file filename in sintassi JSON.   |#
#|  Se filename non esiste, viene creato e se esiste viene          |#
#|  sovrascritto.                                                   |#
#|------------------------------------------------------------------|#



