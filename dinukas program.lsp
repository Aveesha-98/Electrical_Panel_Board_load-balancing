; Global variables
(setq selection_index 1) ; index of the selection
 
(setq file nil)
(setq entities_list nil)  ; Initialize a local list to store the entities


(defun get-attribute (entity attname)
    (setq attdefids (vlax-invoke (vlax-ename->vla-object entity) 'GetAttributes))
    (setq poles 0)
    (foreach attref attdefids
        ; Check if the attribute is "POLOS"
        (if (= (vla-get-TagString attref) "POLOS")
            (progn
                (setq poles (vla-get-TextString attref))
            )
        )
    )
    poles
)


; Function to create circuit from user selected objects
(defun create_circuit (selection_index num_of_phases)
	(setq temp_entities_list nil) ; Intialize entities from the selection set
	(setq selection_set (ssget '((0 . "INSERT"))))  ; Get the selection set of block references
  	(setq found nil)  ; Initialize a variable to track whether a match has been found
  	(setq invalid_poles nil)  ; for load with invalid poles
  	(setq fixed_pole_value -1)
	(if selection_set  ; If something is selected
	    (progn
	        (setq n (sslength selection_set))  ; Get the number of entities in the selection set
	        (setq i 0)  ; Initialize counter
	        (repeat n  ; Repeat for every entity
	            (setq entity (ssname selection_set i))  ; Get the current entity

	            (setq cur_poles (get-attribute entity "POLOS"))
	            ; If the number of phases of the selected load is greater than the number of phases in the circuit

	            (if (< num_of_phases (atoi cur_poles))
	                (progn
                    ; Set found to True
                        (setq invalid_poles t)
                    )
	            )

	            (if (and (> fixed_pole_value 0) (not (= fixed_pole_value (atoi cur_poles))))
	                (progn
                        ; Set found to True
                        (setq invalid_poles t)
                    )
	            )
	            (setq fixed_pole_value (atoi cur_poles))

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


            (cond
                ( (= found t)
                    (progn
                        (princ "\nDuplicate selection.")
                        (princ "\nIgnore selection list.")
                    )
                )

                ( (= invalid_poles t)
                    (progn
                        (princ "\nPoles does not match.")
                        (princ "\nIgnore selection list.")
                    )
                )

                (t
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
                                ; Check if the attribute is "circuit_number"
                                (if (= (vla-get-TagString attref) "CIRCUITO")
                                    (vla-put-TextString attref (itoa selection_index)) ; Update attribute
                                )

                                (princ (vla-get-TagString attref) file) ; write to output file
                                ;(princ (strcat "\nAttribute Tag:" (vla-get-TagString attref)))

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
	)
	(not (or found invalid_poles))
)



; Function to get integer input
(defun get_integer_input (message)
  (setq input (getint message))  ; Get an integer input from the user
  input  ; Return the valid input
)


(defun c:dinukas_program ()

    (setq selection_index 1) ; index of the selection

    (setq file (open "C:\\Users\\sachi\\OneDrive\\Documents\\Dinukas Program\\output.txt" "w"))  ; Open output file for writing
    (if (not file)  ; If the file couldn't be opened
        (progn
            (prompt "\nUnable to open output file.")
            (exit)
        )
    )
    (setq entities_list nil)  ; Initialize a local list to store the entities


	; Get initial inputs from user
	(setq panel_board_name (getstring T "\nEnter panel board name: "))
	(setq num_of_phases (get_integer_input "Enter number of phases: "))
	(setq num_of_circuits (get_integer_input "Enter number of circuits: "))

	;(setq panel_board_name "sachintha")
	;(setq num_of_phases 2)
	;(setq num_of_circuits 25)

  	(princ (strcat "panel board name:" panel_board_name "\n") file) ; write to output file
  	(princ (strcat "number of phases:" (itoa num_of_phases) "\n") file) ; write to output file
	(princ (strcat "num of circuits:" (itoa num_of_circuits)  "\n") file) ; write to output file
	
	(setq continue T)  ; Initialize the loop control variable

	(while continue  ; While the user wants to continue
		(setq yes_no (getstring "\nDo you want to start to create circuits(y/n): "))  ; Get the user's input

		(if (or (= yes_no "n") (= yes_no "N"))  ; If the user entered "no"
			(setq continue nil)  ; Set the loop control variable to nil, which will stop the loop
			(progn
				(setq status (create_circuit selection_index num_of_phases))
			  	(if status
			  		(setq selection_index (+ selection_index 1))  ; Increment selection_index
				)

			)
		)
	)

	(close file) ; close the file
  	(princ "Dinukas program successfully executed.")
)