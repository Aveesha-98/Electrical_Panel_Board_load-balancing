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


(setq selection_set (ssget))  ; Get the selection set
(if selection_set  ; If something is selected
  (progn
    (setq n (sslength selection_set))  ; Get the number of entities in the selection set
    (setq i 0)  ; Initialize counter
    (repeat n  ; Repeat for every entity
      (setq entity (ssname selection_set i))  ; Get the current entity
(princ entity)

      (setq i (+ i 1))  ; Increment counter
    )
    (princ (strcat "\n" (itoa n) " objects processed."))
  )
  (princ "\nNo objects selected.")
)
