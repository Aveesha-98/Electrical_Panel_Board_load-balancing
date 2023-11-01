(defun c:SelectLoads ()
  (setq selection_set (ssget '((0 . "INSERT"))))  ; Get the selection set of block references
  (if selection_set  ; If something is selected
    (progn
      (setq n (sslength selection_set))  ; Get the number of entities in the selection set
      (setq i 0)  ; Initialize counter
      (repeat n  ; Repeat for every entity
        (setq entity (ssname selection_set i))  ; Get the current entity
        (setq data (entget entity))  ; Get DXF group data (properties) for the entity

        ; Get the attribute references of the block reference
        (setq attdefids (vlax-invoke (vlax-ename->vla-object entity) 'GetAttributes))

        ; Print attribute tag and value for each attribute reference
        (foreach attref attdefids
          (princ (strcat "\nAttribute Tag: " (vla-get-TagString attref)))
          (princ (strcat "\nAttribute Value: " (vla-get-TextString attref)))
        )

        (setq i (+ i 1))  ; Increment counter
      )
      (princ (strcat "\n" (itoa n) " blocks processed."))
    )
    (princ "\nNo blocks selected.")
  )
  (princ)
)

(defun c:PrintPropertiesAll ()
  (setq selection_set (ssget))  ; Get the selection set
  (if selection_set  ; If something is selected
    (progn
      (setq n (sslength selection_set))  ; Get the number of entities in the selection set
      (setq i 0)  ; Initialize counter
      (repeat n  ; Repeat for every entity
        (setq entity (ssname selection_set i))  ; Get the current entity
        (setq data (entget entity))  ; Get DXF group data (properties) for the entity
        (princ "\nEntity Properties:")
        (foreach item data  ; Loop over each item in the data
          (print item)  ; Print the item
        )
        (setq i (+ i 1))  ; Increment counter
      )
      (princ (strcat "\n" (itoa n) " objects processed."))
    )
    (princ "\nNo objects selected.")
  )
  (princ)
)

(defun c:ChangeColorAll ()
  (setq selection_set (ssget))  ; Get the selection set
  (if selection_set  ; If something is selected
    (progn
      (setq n (sslength selection_set))  ; Get the number of entities in the selection set
      (setq i 0)  ; Initialize counter
      (repeat n  ; Repeat for every entity
        (setq entity (ssname selection_set i))  ; Get the current entity
        (command "_.change" entity "" "_p" "_c" "1" "")  ; Change color to red
        (setq i (+ i 1))  ; Increment counter
      )
      (princ (strcat "\n" (itoa n) " objects changed color."))
    )
    (princ "\nNo objects selected.")
  )
  (princ)
)

(defun c:WritePropertiesAll ()
  (setq selection_set (ssget))  ; Get the selection set
  (if selection_set  ; If something is selected
    (progn
      (setq file (open "C:\\Users\\sachi\\OneDrive\\Desktop\\New folder\\output2.txt" "w"))  ; Open output file for writing
      (if (not file)  ; If the file couldn't be opened
        (prompt "\nUnable to open output file.")
        (progn  ; If the file was opened successfully
          (setq n (sslength selection_set))  ; Get the number of entities in the selection set
          (setq i 0)  ; Initialize counter
          (repeat n  ; Repeat for every entity
            (setq entity (ssname selection_set i))  ; Get the current entity
            (setq data (entget entity))  ; Get DXF group data (properties) for the entity
            (write-line "\nEntity Properties:" file)
            (foreach item data  ; Loop over each item in the data
              (write-line (vl-princ-to-string item) file)  ; Write the item to the file
            )
            (setq i (+ i 1))  ; Increment counter
          )
          (write-line (strcat "\n" (itoa n) " objects processed.") file)
          (close file)  ; Close the output file
        )
      )
    )
    (prompt "\nNo objects selected.")
  )
  (princ)
)

(setq selection_set (ssget '((0 . "INSERT"))))  ; Get the selection set of block references
	(setq entities_list nil)  ; Initialize a local list to store the entities
	(if selection_set  ; If something is selected
	(progn
	
		; Check whether for duplicate selection
		(setq found nil)  ; Initialize a variable to track whether a match has been found

		(foreach item entities_list  ; For each item in the list
			(if (member item mylist)  ; If the item is in the list
			  	(progn  ; Begin a group of expressions
				        (setq found t)  ; Set the found variable to true
				        (exit)  ; Exit the inner foreach loop
	      			)
			)
		)

		(if found
			  (princ "\nDuplicates selections.")
		  	  (
				(setq n (sslength selection_set))  ; Get the number of entities in the selection set
			      	(setq i 0)  ; Initialize counter
			      	(repeat n  ; Repeat for every entity
				        (setq entity (ssname selection_set i))  ; Get the current entity

				        (setq data (entget entity))  ; Get DXF group data (properties) for the entity

				        ; Get the attribute references of the block reference
				        (setq attdefids (vlax-invoke (vlax-ename->vla-object entity) 'GetAttributes))

				        ; Append the entity to the list
				        (setq entities_list (cons entity entities_list))

				        ; Print attribute tag and value for each attribute reference
				        (foreach attref attdefids
					          (princ (strcat "\nAttribute Tag: " (vla-get-TagString attref)))
					          (princ (strcat "\nAttribute Value: " (vla-get-TextString attref)))
				        )

				        (setq i (+ i 1))  ; Increment counter
			      )
			      (princ (strcat "\n" (itoa n) "  processed."))
			)
		)
	)















































; Global variables
(setq selection_index 1) ; index of the selection
 
(setq file (open "C:\\Users\\sachi\\OneDrive\\Desktop\\eduardogrija437 2\\output.txt" "w"))  ; Open output file for writing
(if (not file)  ; If the file couldn't be opened
	(progn
	  	(prompt "\nUnable to open output file.")
		(exit)
	)
)

(setq entities_list nil)  ; Initialize a local list to store the entities



; Function to create circuit from user selected objects
(defun create_circuit (selection_index)
	(setq temp_entities_list nil) ; Intialize entities from the selection set
	(setq selection_set (ssget '((0 . "INSERT"))))  ; Get the selection set of block references
  	(setq found nil)  ; Initialize a variable to track whether a match has been found
	(if selection_set  ; If something is selected
	    (progn
	        (setq n (sslength selection_set))  ; Get the number of entities in the selection set
	        (setq i 0)  ; Initialize counter
	        (repeat n  ; Repeat for every entity
	            (setq entity (ssname selection_set i))  ; Get the current entity

		    ; If entity is in entities_list
	            (if (member entity entities_list)
	                (progn
			    	; Set found to True
	                    	(setq found t)
			    	
	                    
	                )
	            )

		    ; Add entity to temp_entities_list (At first position)
	            (setq temp_entities_list (cons entity temp_entities_list))
	            (setq i (+ i 1))  ; Increment counter
	        )

	      
	        (if found
		    (princ "\nDuplicate selection.")
	            (princ "\nIgnore selection list.")

		    ; If selection list does not contained previously selected entity
	            (progn
	                (foreach entity temp_entities_list
			  	(princ (strcat "circuit_number:" (itoa selection_index) " ") file) ; write to output file

			  
	                    	(setq data (entget entity))  ; Get DXF group data (properties) for the entity
			  	(setq handle (cdr (assoc 5 data)))  ; Get the handle of the entity

			  	(princ (strcat "object_id:" handle " ") file) ; write entity name to file

			  
	                    	; Get the attribute references of the block reference
	                    	(setq attdefids (vlax-invoke (vlax-ename->vla-object entity) 'GetAttributes))
			  	
	                   	 ; Print attribute tag and value for each attribute reference
	                    	(foreach attref attdefids
				  	(princ (vla-get-TagString attref) file) ; write to output file
	                        	; (princ (strcat "\nAttribute Tag:" (vla-get-TagString attref)))

				  	(princ (strcat ":" (vla-get-TextString attref) " ") file) ; write to output file
	                        	;(princ (strcat "\nAttribute Value:" (vla-get-TextString attref)))
	                    	)
			  	(princ "\n" file) ; write to output file
			    	(setq entities_list (cons entity entities_list))
			  	(command "_.change" entity "" "_p" "_c" "1" "")  ; Change color to red
			  	
				
	                )
	                (princ (strcat "\n" (itoa (length entities_list)) " objects selected."))
	            )
	        )
	    )
	)
	(not found)
)



; Function to get integer input
(defun get_integer_input (message)
  (setq input (getint message))  ; Get an integer input from the user
  input  ; Return the valid input
)

; Get initial inputs from user
(setq panel_board_name (getstring T "\nEnter panel board name: "))
(setq num_of_phases (get_integer_input "Enter number of phases: "))
(setq num_of_circuits (get_integer_input "Enter number of circuits: "))



(setq continue T)  ; Initialize the loop control variable

(while continue  ; While the user wants to continue
	(setq yes_no (getstring "\nDo you want to start to create circuits(y/n): "))  ; Get the user's input

	(if (or (= yes_no "n") (= yes_no "N"))  ; If the user entered "no"
		(setq continue nil)  ; Set the loop control variable to nil, which will stop the loop
		(progn
			(setq status (create_circuit selection_index))
		  	(if status
		  		(setq selection_index (+ selection_index 1))  ; Increment selection_index
			)

		)
	)
)

(close file) ; close the file




; Change color of a object using handler
(setq entity (handent "2AF")) ; 2AF => Handle Read from the file
(command "_.change" entity "" "_p" "_c" "1" "")















(setq selection_index 1) ; index of the selection
 
(setq file (open "C:\\Users\\sachi\\OneDrive\\Desktop\\eduardogrija437 2\\output.txt" "w"))  ; Open output file for writing
(if (not file)  ; If the file couldn't be opened
	(progn
	  	(prompt "\nUnable to open output file.")
		(exit)
	)
)


	
(setq entities_list nil)  ; Initialize a local list to store the entities
	  
(setq temp_entities_list nil) ; Intialize entities from the selection set
(setq selection_set (ssget '((0 . "INSERT"))))  ; Get the selection set of block references
(if selection_set  ; If something is selected
    (progn
        (setq found nil)  ; Initialize a variable to track whether a match has been found
        (setq n (sslength selection_set))  ; Get the number of entities in the selection set
        (setq i 0)  ; Initialize counter
        (repeat n  ; Repeat for every entity
            (setq entity (ssname selection_set i))  ; Get the current entity

	    ; If entity is in entities_list
            (if (member entity entities_list)
                (progn
		    	; Set found to True
                    	(setq found t)
		    	(princ "\nDuplicate Selection")
                    
                )
            )

	    ; Add entity to temp_entities_list (At first position)
            (setq temp_entities_list (cons entity temp_entities_list))
            (setq i (+ i 1))  ; Increment counter
        )

      
        (if found
            (princ "\nIgnore selection list")

	    ; If selection list does not contained previously selected entity
	    (write-line (strcat "\nCircuit Number: " selection_index) file) ; write to output file
            (progn
                (foreach entity temp_entities_list
                    	(setq data (entget entity))  ; Get DXF group data (properties) for the entity
		  
                    	; Get the attribute references of the block reference
                    	(setq attdefids (vlax-invoke (vlax-ename->vla-object entity) 'GetAttributes))
		  
                   	 ; Print attribute tag and value for each attribute reference
                    	(foreach attref attdefids
			  	(write-line (strcat "\nAttribute Tag: " (vla-get-TagString attref)) file) ; write to output file
                        	(princ (strcat "\nAttribute Tag: " (vla-get-TagString attref)))

			  	(write-line (strcat "\nAttribute Value: " (vla-get-TextString attref)) file) ; write to output file
                        	(princ (strcat "\nAttribute Value: " (vla-get-TextString attref)))
                    	)
		    	(setq entities_list (cons entity entities_list))
		  	(command "_.change" entity "" "_p" "_c" "1" "")  ; Change color to red
		  	
			
                )
                (princ (strcat "\n" (itoa (length entities_list)) " objects processed."))
            )
        )
    )
)
(princ)

(close file) ; close the file