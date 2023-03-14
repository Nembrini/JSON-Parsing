#|--------------------------|#
#|  Nembrini Filippo 886135 |#
#|--------------------------|#

#|------------------------------------------------------------------|#
#|	REGOLE PER LA STESURA DEL CODICE:			    |#
#|	1)Il testo non deve MAI superare le 80 colonne di ampiezza. |#
#|	2)Il testo deve essere correttamente indentato.		    |#
#|	3)Gli operatori in C/C++ e Prolog (e Python,R,Haskell,etc)  |#
#|	  vanno sempre delimitati correttamente:		    |# 
#|	  spazi attorno agli operatori eccezion fatta per le virgole|#
#| 	  , che hanno solo uno spazio dopo. 			    |#
#|------------------------------------------------------------------|#

#|------------------------------------------------------------------|#
#|	In questo codice saranno presenti commenti che descrivono il|#
#|	funzionamento di ogni predicato.			    |#
#|------------------------------------------------------------------|#



#|------------------|#
#|  JSONPARSE.LISP  |#
#|------------------|#



#|------------------------------------------------------------------|#
#|	             jsonparse(JSONString, Object).	            |#
#|------------------------------------------------------------------|#
#|    Accetta in ingresso una stringa e produce una struttura       |#
#|    simile a quella illustrata per la realizzazione Prolog.       |#
#|------------------------------------------------------------------|#

(defun jsonparse (JSONString)
  (let ((JSONList (formatfixer (coerce JSONString 'list))))
    (or (objectchecker JSONList)
        (arraychecker JSONList)
        (error "ERROR: syntax error"))))


#|------------------------------------------------------------------|#
#|  Controlla se l'input è un Numero                                |#
#|------------------------------------------------------------------|#

(defun numberchecker (number)
  (cond ((or (eql (car number) #\-) 
             (eql (car number) #\+)
             (digit-char-p (car number)))
         (multiple-value-bind (result add) 
             (intchecker (cdr number))
           (values (car (multiple-value-list 
                         (read-from-string 
                          (coerce 
                           (cons (car number) result) 'string)))) add)))
        (T (error "ERROR: syntax error"))))

#|------------------------------------------------------------------|#
#|  Controlla se l'input è un Intero                                |#
#|------------------------------------------------------------------|#

(defun intchecker (integer)
  (if (null (car integer)) nil
    (cond ((and (eql (car integer) #\.)
                (digit-char-p (second integer)))
           (multiple-value-bind (result more_integer) 
               (floatchecker (cdr integer))
             (values (cons (car integer) result) more_integer)))
          ((digit-char-p (car integer))
           (multiple-value-bind (result more_integer) 
               (intchecker (cdr integer))
             (values (cons (car integer) result) more_integer)))
          (T (values nil integer)))))                                       


#|------------------------------------------------------------------|#
#|  Controlla se l'input è un Numero con Decimali                   |#
#|------------------------------------------------------------------|#

(defun floatchecker (float)
  (if (null (car float)) nil
    (if (digit-char-p (car float))
        (multiple-value-bind (result more_float) 
            (floatchecker (cdr float))
          (values (cons (car float) result) more_float))
      (values nil float))))
     

#|------------------------------------------------------------------|#
#|  Controlla se l'inizio dell'input ha un singolo apice       |#
#|------------------------------------------------------------------|#

(defun firstcharchecker (chars end)
  (if (eql (car chars) end) (values nil (cdr chars))
    (if (and (<= (char-int (car chars)) 128) 
             (<= (char-int (car chars)) 128))
        (multiple-value-bind (result more_chars) 
            (firstcharchecker (cdr chars) end)
          (values (cons (car chars) result) more_chars))
      (error "ERROR: syntax error"))))


#|------------------------------------------------------------------|#
#|  Controlla se l'inizio dell'input ha un doppio apice             |#
#|------------------------------------------------------------------|#

(defun secondcharchecker (chars end)
  (if (eql (car chars) end) (values nil (cdr chars))
    (if (and (<= (char-int (car chars)) 128) 
             (<= (char-int (car chars)) 128))
        (multiple-value-bind (result more_chars) 
            (secondcharchecker (cdr chars) end)
          (values (cons (car chars) result) more_chars))
      (error "ERROR: syntax error"))))


#|------------------------------------------------------------------|#
#|  Controlla se l'input è un Stringa                               |#
#|------------------------------------------------------------------|#

(defun stringchecker (string)
  (cond ((eql (car string) #\")
         (multiple-value-bind (result more_string_DQ) 
             (firstcharchecker (cdr string) (car string))
           (values (coerce result 'string) more_string_DQ)))
        ((eql (car string) #\')
         (multiple-value-bind (result more_string_SQ) 
             (secondcharchecker (cdr string) (car string))
           (values (coerce result 'string) more_string_SQ)))
        (T (error "ERROR: syntax error")))) 


#|------------------------------------------------------------------|#
#|  Controlla se l'input è un Array                                 |#
#|------------------------------------------------------------------|#

(defun arraychecker (array)
  (if (eql (car array) #\[)
      (if (eql (second array) #\])
          (values (list 'jsonarray) (cdr (cdr array)))
        (multiple-value-bind (result more_array) 
            (elementchecker (cdr array))
          (if (eql (car more_array) #\])
              (values (cons 'jsonarray result) (cdr more_array))
            (error "ERROR: syntax error"))))
    (values nil array)))


#|------------------------------------------------------------------|#
#|  Controlla se l'input è un determinato Simbolo                   |#
#|------------------------------------------------------------------|#

(defun casechecker (value)
  (cond ((eql (car value) #\{) 
         (objectchecker value))
        ((eql (car value) #\[) 
         (arraychecker value))
        ((or (eql (car value) #\") 
             (eql (car value) #\')) 
         (stringchecker value))
        ((or (eql (car value) #\+) 
             (eql (car value) #\-) 
             (digit-char-p (car value))) (numberchecker value))
        (T (error "ERROR: syntax error"))))


#|------------------------------------------------------------------|#
#|  Controlla se l'input è una Coppia                               |#
#|------------------------------------------------------------------|#

(defun doublechecker (double)
  (multiple-value-bind (result additionadouble) 
      (stringchecker double)
    (if (or (null result)
            (null additionadouble))
        (error "ERROR: syntax error")
      (if (eql (car additionadouble) #\:)
          (multiple-value-bind (caradditionaldouble cdradditionaldouble) 
              (casechecker (cdr additionadouble))
            (if (null caradditionaldouble)
                (error "ERROR: syntax error")
              (values (list result caradditionaldouble) cdradditionaldouble)))
        (error "ERROR: syntax error")))))
          

#|------------------------------------------------------------------|#
#|  Controlla se l'input è una Membro                               |#
#|------------------------------------------------------------------|#

(defun memberchecker (member)
  (multiple-value-bind (result more_member) 
      (doublechecker member)
    (if (null result)
        (error "ERROR: syntax error")
      (if (eql (car more_member) #\,)
          (multiple-value-bind (result_more_member rest_more_member) 
              (memberchecker (cdr more_member))
            (if (null result_more_member)
                (error "ERROR: syntax error")
              (values (cons result result_more_member) rest_more_member)))
        (values (cons result nil) more_member)))))


#|------------------------------------------------------------------|#
#|  Controlla se l'input è una Oggetto                              |#
#|------------------------------------------------------------------|#

(defun objectchecker (object)
  (if (eql (car object) #\{)
      (if (eql (second object) #\})
          (values (list 'jsonobj) (cdr (cdr object)))
        (multiple-value-bind (result more_object) 
            (memberchecker (cdr object))
          (if (eql (car more_object) #\})
              (values (cons 'jsonobj result) (cdr more_object))
            (error "ERROR: syntax error"))))
    (values nil object)))


#|------------------------------------------------------------------|#
#|  Controlla se l'input è un Elemento                              |#
#|------------------------------------------------------------------|#

(defun elementchecker (element)
  (multiple-value-bind (result more_element) 
      (casechecker element)
    (if (null result)
        (error "ERROR: syntax error")
      (if (eql (car more_element) #\,)
  (multiple-value-bind (finalelements elementadjuntive) 
              (elementchecker (cdr more_element))
            (if (null finalelements)
                (error "ERROR: syntax error")
              (values (cons result finalelements) elementadjuntive)))
        (values (cons result nil) more_element)))))
    
            
#|------------------------------------------------------------------|#
#|  Funzioni Ausiliarie                                   	    |#
#|------------------------------------------------------------------|#

(defun analyzer (pos)
  (cond ((null pos)
         pos)
        ((atom pos)
         (list pos))
        (T (append (analyzer (first pos))
                   (analyzer (rest pos))))))
    
(defun formatfixer (list)
  (let ((start (car list)))
    (cond ((or (eql start #\Space)
               (eql start #\Tab)
               (eql start #\NewLine))
           (formatfixer (cdr list)))
          ((or (eql start #\") 
               (eql start #\')) 
           (cons start (formatanalyzer (cdr list) start)))
          ((null start) nil)
          (T (cons start (formatfixer (cdr list)))))))

(defun formatanalyzer (list end)
  (let ((start (car list)))
    (cond ((null start) nil)
          ((eql start end) (cons start (formatfixer (cdr list))))
          (T (cons start (formatanalyzer (cdr list) end))))))


#|------------------------------------------------------------------|#
#|	           jsonaccess(JSONObj Fields Result). 	            |#
#|------------------------------------------------------------------|#
#|	Accetta un oggetto JSON (rappresentato in Common Lisp, così |#
#|  come prodotto dalla funzione jsonparse) e una serie di “campi”, |#
#|  recupera l’oggetto corrispondente. Un campo rappresentato da    |#
#|  Pos (con Pos un numero maggiore o uguale a 0) rappresenta un    |#
#|  indice di un array JSON.                                        |#
#|------------------------------------------------------------------|#

(defun jsonaccess (json &rest fields)
  (if (null json)
      (error "ERROR: syntax error")
    (if (null fields)
        json
      (let ((start (car json)))
        (cond ((eq start 'jsonobj)
               (let ((field (assoc (car fields)
                                   (cdr json)
                                   :test 'equalp)))
                 (jsonaccesstwo (second field) fields)))
              ((eq start 'jsonarray)
               (if (numberp (car fields))
                   (let ((field (nth (car fields)
                                     (cdr json))))
                     (jsonaccesstwo field fields))
                 (error "ERROR: syntax error")))
              (T (error "ERROR: syntax error")))))))

(defun jsonaccesstwo (field fields)
  (if (null field)
      (error "ERROR: syntax error")
    (apply 'jsonaccess field (cdr fields))))
              

#|------------------------------------------------------------------|#
#|	                    jsonread(Filename) 	                    |#
#|------------------------------------------------------------------|#
#|	Apre il file filename ritorna un oggetto JSON               |#
#|  (o genera un errore). Se filename non è accessibile la funzione |#
#|  genera un errore.                                               |#
#|------------------------------------------------------------------|#

(defun jsonread (filename)
  (with-open-file (in filename
                      :if-does-not-exist :error
                      :direction :input)
    (jsonparse (coerce (read-line in) 'string))))


#|------------------------------------------------------------------|#
#|  Funzioni Ausiliarie                                   	    |#
#|------------------------------------------------------------------|#

(defun valueprinter (json)
  (cond ((null json)
         nil)
        ((numberp json)
         (coerce (write-to-string json) 'list))
        ((stringp json)
         (list #\" (coerce json 'list) #\"))
        ((eq (car json) 'jsonobj)
         (objectprinter json))
        ((eq (car json) 'jsonarray)
         (arrayprinter json))))

(defun arrayprinter (json)
  (if (eq (car json) 'jsonarray)
      (if (null (cdr json)) 
          (list #\[ #\])
        (list #\[ (write-element (cdr json)) #\]))
    nil))

(defun pairprinter (json)
  (if (null (cdr json))
      (list (valueprinter (car (car json)))
            #\:
            (valueprinter (car (cdr (car json)))))
    (list (valueprinter (car (car json)))
          #\:
          (valueprinter (car (cdr (car json))))
          #\,
          (pairprinter (cdr json)))))

(defun elementprinter (json)
  (if (null (cdr json))
      (list (valueprinter (car json)))
    (list (valueprinter (car json))
          #\,
          (elementprinter (cdr json)))))

(defun objectprinter (json)
  (if (eq (car json) 'jsonobj)
      (if (null (cdr json)) 
          (list #\{ #\})
        (list #\{ (pairprinter (cdr json)) #\}))
    nil))


#|------------------------------------------------------------------|#
#|	                    jsondump(JSON FileName) 	            |#
#|------------------------------------------------------------------|#
#|	Scrive l’oggetto JSON sul file filename in sintassi JSON.   |#
#|  Se filename non esiste, viene creato e se esiste viene          |#
#|  sovrascritto.                                                   |#
#|------------------------------------------------------------------|#

(defun jsondump (json filename)
  (if (or (null json)
          (null filename))
      (error "ERROR: jsondump")
    (with-open-file (out filename
                         :direction :output
                         :if-exists :supersede
                         :if-does-not-exist :create)
      (format out "~A" (coerce (flatten (or (objectprinter json)
                                            (arrayprinter json))) 'string))))
  filename)

