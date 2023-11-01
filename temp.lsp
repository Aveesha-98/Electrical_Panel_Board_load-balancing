(defun c:getSelectedObjectDetails()
  (setq eName(car (entsel)))

  (entget eName)
)

(defun c:ChangeColorAll (/ selection_set n i entity)
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