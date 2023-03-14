/*--------------------------------------*/
/*	Nembrini Filippo 886135		*/
/*--------------------------------------*/

/*----------------------------------------------------------------------*/
/*   REGOLE PER LA STESURA DEL CODICE:					*/
/*   1)Il testo non deve MAI superare le 80 colonne di ampiezza.  	*/
/*   2)Il testo deve essere correttamente indentato.		     	*/
/*   3)Gli operatori in C/C++ e Prolog (e Python, R, Haskell, etc)	*/
/*     vanno sempre delimitati correttamente:		      		*/ 
/*     spazi attorno agli operatori eccezion fatta per le virgole,	*/
/*     che hanno solo uno spazio dopo. 			     		*/
/*----------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
/*	In questo codice saranno presenti commenti che descrivono il */
/*	funzionamento di ogni predicato.			     */
/*-------------------------------------------------------------------*/



/*----------------------*/
/*	JSONPARSE.PL	*/
/*----------------------*/



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
/*  Caso jsonparse che prende in input un Oggetto      	                */
/*----------------------------------------------------------------------*/

jsonparse({}, jsonobj([])) :- !.

jsonparse(JSONString, jsonobj(ObjectFixed)) :-
	string(JSONString),
    string_chars(JSONString, Chars),
    tilderemover(Chars, CharsFixed),
    string_chars(JSONStringFixed, CharsFixed),
    catch(term_string(JSON, JSONStringFixed), _, false),
    JSON =.. [{}, Object],
    jsonobj([Object], ObjectFixed),
    !.

jsonparse(JSONAtom, JSONCheck) :-
    atom(JSONAtom),
    atom_string(JSONAtom, JSONString),
    jsonparse(JSONString, JSONCheck),
    !.

jsonparse(JSON, jsonobj(ObjectFixed)) :-
    JSON =.. [{}, Object],
    jsonobj([Object], ObjectFixed),
    !.


/*----------------------------------------------------------------------*/
/*  Caso jsonparse che prende in input un Array        	                */
/*----------------------------------------------------------------------*/

jsonparse(StringsArray, jsonarray(ArrayFixed)) :-
	string(StringsArray),
    catch(term_string(Array, StringsArray), _, false),
    jsonarray(Array, ArrayFixed),
    !.

jsonparse(ArrayAtom, JSONCheck) :-
    atom(ArrayAtom),
    atom_string(ArrayAtom, StringsArray),
    jsonparse(StringsArray, JSONCheck),
    !.

jsonparse(Array, jsonarray(ArrayFixed)) :-
    jsonarray(Array, ArrayFixed),
    !.
    
/*----------------------------------------------------------------------*/
/*  Caso jsonobj che prende in input un Oggetto   	                */
/*----------------------------------------------------------------------*/

jsonobj([], []) :- !.

jsonobj([Member], [MemberFixed]) :-
    jsonmember(Member, MemberFixed),
    !.

jsonobj([Object], [MemberFixed | MembersFixed]) :-
    Object =.. [',', Member | MembersAdditional],
    jsonmember(Member, MemberFixed),
    jsonobj(MembersAdditional, MembersFixed),
    !.


/*----------------------------------------------------------------------*/
/*  Caso jsonarray che prende in input un Elemento     	                */
/*----------------------------------------------------------------------*/

jsonarray([], []) :- !.

jsonarray([Value | ElementsAdditional], [ValueFixed | ElementsFixed]) :-
    valuer(Value, ValueFixed),
    jsonarray(ElementsAdditional, ElementsFixed),
    !.


/*----------------------------------------------------------------------*/
/*  Caso jsonmember che prende in input un membro              	        */
/*----------------------------------------------------------------------*/

jsonmember(Member, (AttributeFixed, ValueFixed)) :-
    Member =.. [':', Attribute, Value],
    jsonpair(Attribute, Value, AttributeFixed, ValueFixed),
    !.


/*----------------------------------------------------------------------*/
/*  Caso jsonpair che prende in input una Coppia               	        */
/*----------------------------------------------------------------------*/

jsonpair(Attribute, Value, Attribute, ValueFixed) :-
    string(Attribute),
    valuer(Value, ValueFixed),
    !.


/*------------------------------------------------------------------*/
/*  Caso valuer che prende in input un tipo di Valore               */
/*------------------------------------------------------------------*/

valuer([], []) :- !.

valuer(Value, Value) :-
    string(Value), !.

valuer(Value, Value) :-
    number(Value), !.

valuer(Value, ValueFixed) :-
    jsonparse(Value, ValueFixed), !.



/*----------------------------------------------------------------------*/
/*	           jsonaccess(Jsonobj, Fields, Result).	                */
/*----------------------------------------------------------------------*/
/*	Risulta vero quando Result è recuperabile seguendo la catena    */
/*  di campi presenti in Fields (una lista) a partire da Jsonobj.   	*/
/*  Un campo rappresentato da Posiz (con Posiz un numero maggiore o 	*/
/*  uguale a 0) corrisponde a un indice di un array JSON.           	*/
/*----------------------------------------------------------------------*/

/*------------------------------------------------------------------*/
/*  Caso in cui Fields è una Lista                             	    */
/*------------------------------------------------------------------*/

jsonaccess(ResultUncomplete, [], ResultUncomplete) :- !.

jsonaccess(jsonobj(ObjectFixed), [Field | Fields], Result) :-
    jsonaccess(jsonobj(ObjectFixed), Field, ResultUncomplete),
    jsonaccess(ResultUncomplete, Fields, Result),
    !.

jsonaccess(jsonarray(ArrayFixed), [Field | Fields], Result) :-
    jsonaccess(jsonarray(ArrayFixed), Field, ResultUncomplete),
    jsonaccess(ResultUncomplete, Fields, Result),
    !.


/*  jsonaccess(json_array(), _, _) :- !, fail.  */


/*------------------------------------------------------------------*/
/*  Caso in cui Fields è una Strings di tipo SWI Prolog             */
/*------------------------------------------------------------------*/

jsonaccess(jsonobj(ObjectFixed), String, Result) :-
    string(String),
    finditem(ObjectFixed, String, Result),
    !.

/*------------------------------------------------------------------*/
/*  Caso in cui Fields è un Numero                                  */
/*------------------------------------------------------------------*/

jsonaccess(jsonarray(ArrayFixed), Posiz, Result) :-
    number(Posiz),
    findpos(ArrayFixed, Posiz, Result),
    !.

/*------------------------------------------------------------------*/
/*  Predicato per cercare tra gli Oggetti uno specifico             */
/*------------------------------------------------------------------*/

finditem(_, [], _) :-
    fail,
    !.

finditem([(FirstItem, SecondItem) | _], String, Result) :-
    String = FirstItem,
    Result = SecondItem,
    !.

finditem([(_) | Items], String, Result) :-
    finditem(Items, String, Result),
    !.


/*------------------------------------------------------------------*/
/*  Predicato per prelevare un atomo in posizione Posiz in un Array */
/*------------------------------------------------------------------*/

findpos([Item | _], 0, Item) :- !.

findpos([], _, _) :-
    fail,
    !.

findpos([_ | Items], Posiz, Result) :-
    Posiz > 0,
    PosizFixed is Posiz-1,
    findpos(Items, PosizFixed, Result),
    !.


/*------------------------------------------------------------------*/
/*  Corregge il formato delle Stringhe                              */
/*------------------------------------------------------------------*/

tilderemover(['\'' | CharTail], ['"' | CharsRemaining]) :-
    tilderemover(CharTail, CharsRemaining),
    !.

tilderemover([Char | CharTail], [Char | CharsRemaining]) :-
    tilderemover(CharTail, CharsRemaining),
    !.

tilderemover([], []) :- !.


/*------------------------------------------------------------------*/
/*  Predicato che trasforma nella corretta sintassi in JSON         */
/*------------------------------------------------------------------*/

jsonsyntaxtransformer(jsonarray(O), JSONString) :-
    jsonparse(JSONString, jsonarray(O)),
    !.

jsonsyntaxtransformer(jsonobj([]), {}) :- !.

jsonsyntaxtransformer(jsonobj(O), JSONString) :-
    jsonsyntaxtransformer(O, Pairs),
    JSONString =.. [{}, Pairs],
    !.

jsonsyntaxtransformer([], []) :- !.

jsonsyntaxtransformer([], [ObjectChecks]) :-
    JSONString =.. [{}, ObjectChecks],
    jsonsyntaxtransformer([], JSONString),
    !.

jsonsyntaxtransformer(([(One, jsonarray(Two)) | Objects]), [Pair | Pairs]) :-
    jsonparse(Array, jsonarray(Two)),
    Pair =.. [':', One, Array],
    jsonsyntaxtransformer(Objects, Pairs),
    !.

jsonsyntaxtransformer(([(One, Two) | Objects]), [Pair | Pairs]) :-
    Pair =.. [':', One, Two],
    jsonsyntaxtransformer(Objects, Pairs),
    !.

jsonsyntaxcorrector(Term, JSONString) :-
    term_string(Term, String),
    string_chars(String, Chars),
    correctformatcorrector(Chars, ParsedChars),
    string_chars(JSONString, ParsedChars),
    !.


/*------------------------------------------------------------------*/
/*  Predicato che corregge il formato rimuovendo parentesi          */
/*  e aggiungendo spazi dove è necessario                           */
/*------------------------------------------------------------------*/

correctformatcorrector(['{', '[' | CharsTail], ['{' | RemainingChars]) :-
    correctformatcorrector(CharsTail, RemainingChars),
    !.

correctformatcorrector([']', '}'], ['}']) :- !.

correctformatcorrector([':' | CharsTail], [' ', ':', ' ' | RemainingChars]) :-
    correctformatcorrector(CharsTail, RemainingChars),
    !.

correctformatcorrector([',' | CharsTail], [',', ' ' | RemainingChars]) :-
    correctformatcorrector(CharsTail, RemainingChars),
    !.

correctformatcorrector([Char | CharsTail], [Char | RemainingChars]) :-
    correctformatcorrector(CharsTail, RemainingChars),
    !.
    

/*------------------------------------------------------------------*/
/*	                    jsonread(Filename, JSON).	            */
/*------------------------------------------------------------------*/
/*  Apre il file FileName e ha successo se riesce a costruire un    */
/*  oggetto JSON. Se FileName non esiste il predicato fallisce.     */
/*------------------------------------------------------------------*/

jsonread(FileName, JSON) :-
    catch(open(FileName, read, File), _, false),
    read_string(File, _, O),
    atom_string(Atom, O),
    catch(jsonparse(Atom, JSON), _, false),
    close(File).

/*------------------------------------------------------------------*/
/*	                    jsondump(JSON, FileName).	            */
/*------------------------------------------------------------------*/
/*  Scrive l’oggetto JSON sul file FileName in sintassi JSON.	    */
/*  Se FileName non esiste, viene creato e se esiste viene          */
/*  sovrascritto                                                    */
/*------------------------------------------------------------------*/

jsondump(JSON, FileName) :-
    atom(FileName),
    jsonsyntaxtransformer(JSON, Term),
    jsonsyntaxcorrector(Term, JSONAtom),
    open(FileName, write, File),
    write(File, JSONAtom),
    close(File),
    !.

jsondump(JSON, FileName) :-
    atom(FileName),
    jsonsyntaxtransformer(JSON, JSONString),
    open(FileName, write, File),
    write(File, JSONString),
    close(File),
    !.


