README PARTE PROLOG

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
Dovete costruire un parser per le stringhe JSON che abbiamo descritto. 
La stringa in input va analizzata ricorsivamente per comporre una 
struttura adeguata a memorizzarne le componenti. Si cerchi di costruire 
un parser guidato dalla struttura ricorsiva del testo in input. 
Ad esempio, un eventuale array (e la sua composizione interna in elements) 
va individuato dopo l’individuazione del member del quale fa parte, e il 
meccanismo di ricerca non deve ripartire dalla stringa iniziale ma bensì 
dal risultato della ricerca del member stesso.

In altre parole, approcci del tipo “ora cerco la posizione del ‘:’ e poi 
prendo la sottostringa…”, non sono il modo migliore di affrontare in 
problema. Anzi: quasi sicuramente porteranno ad un programma estremamente 
complicato, poco funzionante e quindi… insufficiente.

Predicati Usati:
/*----------------------------------------------------------------------*/
/*	                jsonparse(JSONString, Object).	                */
/*----------------------------------------------------------------------*/
/*  Risulta vero se JSONString (una stringa SWI Prolog o un atomo	*/
/*  Prolog) può venirescorporata come stringa, numero, o nei        	*/
/*  termini composti:                                               	*/
/*  Object = jsonobj(Members)						*/
/*  Object = jsonarray(Elements)					*/
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*	           jsonaccess(Jsonobj, Fields, Result).	                */
/*----------------------------------------------------------------------*/
/*	Risulta vero quando Result è recuperabile seguendo la catena    */
/*  di campi presenti in Fields (una lista) a partire da Jsonobj.   	*/
/*  Un campo rappresentato da Posiz (con Posiz un numero maggiore o 	*/
/*  uguale a 0) corrisponde a un indice di un array JSON.           	*/
/*----------------------------------------------------------------------*/


/*------------------------------------------------------------------*/
/*	           	finditem/2				    */
/*------------------------------------------------------------------*/
/*  Predicato per cercare tra gli Object uno specifico              */
/*------------------------------------------------------------------*/

/*------------------------------------------------------------------*/
/*	           	findpos/2				    */
/*------------------------------------------------------------------*/
/*  Predicato per prelevare un atomo in posizione Posiz in un Array */
/*------------------------------------------------------------------*/


/*------------------------------------------------------------------*/
/*	           tilderemover/2				    */
/*------------------------------------------------------------------*/
/*  Predicato che corregge il formato rimuovendo parentesi          */
/*  e aggiungendo spazi dove è necessario                           */
/*------------------------------------------------------------------*/

/*------------------------------------------------------------------*/
/*	           jsonsyntaxtransformer/2.	                    */
/*------------------------------------------------------------------*/
/*  Predicato che trasforma nella corretta sintassi in JSON         */
/*------------------------------------------------------------------*/

/*------------------------------------------------------------------*/
/*	           correctformatcorrector/2.	                    */
/*------------------------------------------------------------------*/
/*  Predicato che corregge il formato rimuovendo parentesi          */
/*  e aggiungendo spazi dove è necessario                           */
/*------------------------------------------------------------------*/

/*------------------------------------------------------------------*/
/*	                    jsonread(Filename, JSON).	            */
/*------------------------------------------------------------------*/
/*  Apre il file FileName e ha successo se riesce a costruire un    */
/*  oggetto JSON. Se FileName non esiste il predicato fallisce.     */
/*------------------------------------------------------------------*/

/*------------------------------------------------------------------*/
/*	                    jsondump(JSON, FileName).	            */
/*------------------------------------------------------------------*/
/*  Scrive l’oggetto JSON sul file FileName in sintassi JSON.	    */
/*  Se FileName non esiste, viene creato e se esiste viene          */
/*  sovrascritto                                                    */
/*------------------------------------------------------------------*/














