;;; .init.local.el -*- lexical-binding: t; -*-
(radian-local-on-hook after-init

  (setq org-directory    "~/org/gtd/")

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.

(setq mu4e-maildir-shortcuts
      '( ("/INBOX"               . ?i)
         ("/sent"                . ?s)
         ("/trash"               . ?t)
         ("/all"              . ?a)))



  (setq mu4e-sent-folder       "/atea/sent")
  (setq mu4e-drafts-folder     "/atea/drafts")
  (setq mu4e-trash-folder      "/atea/trash")
  (setq mu4e-refile-folder     "/atea/all")
  (setq smtpmail-smtp-user     "agasson@ateasystems.com")
  (setq user-mail-address      "agasson@ateasystems.com")
  (setq mu4e-compose-signature "---\nAndrés Gasson(Gas)")

(use-package org-gcal
  :after '(auth-source-pass password-store)
  :config
  (setq org-gcal-client-id "887865341451-orrpnv3cu0fnh8hdtge77sv6csqilqtu.apps.googleusercontent.com"
        org-gcal-client-secret "WmOGOCr_aWPJSqmwXHV-29bv"
        org-gcal-file-alist
        '(("agasson@ateasystems.com" . "~/org/gtd/calendars/atea-cal.org")
          ;;("ateasystems.com_0ie21uc26j0a41g60b8f99mh1k@group.calendar.google.com" . "~/org/gtd/calendars/changecontrol-cal.org")
          )))

(use-package org-pomodoro
  :after '(org-gcal)
  :commands (org-pomodoro)
  )

;; ORG config
;;(after! org
        ;; set org file directory

        (defconst gas-org-agenda-file (concat org-directory "inbox.org"))
        (defconst gas-org-work-file (concat org-directory "atea.org"))
        (defconst gas-org-journal-file (concat org-directory "journal.org"))
        (defconst gas-org-refile-file (concat org-directory "refile.org"))
        ;; set agenda files
        (setq org-agenda-files (list org-directory))


     ;;   (add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))

     ;; (use-package! org
     ;;  :bind (("C-c C-x C-i" . gas-punch-in)
     ;;         ("C-c C-x C-o" . gas-punch-out))
     ;;   )

        (setq
         org-ellipsis " ↴ ")

        (setq-default
         org-treat-S-cursor-todo-selection-as-state-change nil
         org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM"
         org-global-properties '(("Effort_ALL" . "0:15 0:30 0:45 1:00 1:30 2:00 3:00 4:00 5:00 7:00")))


        (setq-default org-tag-alist (quote (("errand" . ?e)
                                            ("bureau" . ?o)
                                            ("maison" . ?h)
                                            ("important"  . ?i)
                                            ("urgent"  . ?u)
                                            (:newline)
                                            ("RÉUNION"   . ?m)
                                            ("TÉLÉPHONE" . ?p))))

        (setq  org-highest-priority ?A
               org-default-priority ?C
               org-lowest-priority  ?D)

        (org-babel-do-load-languages
         'org-babel-load-languages
         '((calc    . t)
           (gnuplot . t)
           (clojure . t)
           (latex   . t)
           (matlab  . t)
           (octave  . t)
           (python  . t)
           (shell   . t)))


        (setq org-agenda-custom-commands
              (quote (
                      ("N" "Notes" tags "NOTE"
                       ((org-agenda-overriding-header "Notes")
                        (org-tags-match-list-sublevels t)))
                      ("h" "Habitudes" tags-todo "STYLE=\"habit\""
                       ((org-agenda-overriding-header "Habitudes")
                        (org-agenda-sorting-strategy
                         '(todo-state-down priority-down category-keep))))
                      ("e" "Eisenhower Matrix"
                       ((agenda "" ((org-agenda-overriding-header "Calendrier Eisenhower:")
                                    (org-agenda-show-log t)
                                    (org-agenda-log-mode-items '(clock state))
                                    (org-agenda-category-filter-preset '("-Habitudes"))
                                    (org-agenda-span 5)
                                    (org-agenda-start-on-weekday t)
                        ;;            (org-agenda-ndays 5)
                        ;;            (org-agenda-start-day "-2d")
                                    (org-deadline-warning-days 30)))
                        (tags-todo  "+important+urgent\!FINI"
                                   ((org-agenda-overriding-header "Tâches importantes et urgentes")
                                    (org-tags-match-list-sublevels nil)))
                        (tags-todo  "+important-urgent"
                                   ((org-agenda-overriding-header "Tâches importantes mais non urgentes")
                                    (org-tags-match-list-sublevels nil)))
                        (tags-todo "-important+urgent"
                                   ((org-agenda-overriding-header "Tâches urgentes mais sans importance")
                                    (org-tags-match-list-sublevels nil)))
                        (tags-todo "-important-urgent/!TODO"
                                   ((org-agenda-overriding-header "Tâches non importantes ni urgentes")
                                      (org-agenda-category-filter-preset '("-Habitudes"))
                                    (org-tags-match-list-sublevels nil)))
                        (tags-todo "VALUE"
                                   ((org-agenda-overriding-header "Valeurs")
                                    (org-tags-match-list-sublevels nil)))
                        ))
                      (" " "Agenda"
                       ((agenda "" ((org-agenda-overriding-header "Calendrier d'aujourd'hui:")
                                    (org-agenda-show-log t)
                                    (org-agenda-log-mode-items '(clock state))
                                 ;;   (org-agenda-span 'day)
                                 ;;   (org-agenda-ndays 3)
                                    (org-agenda-start-on-weekday nil)
                                    (org-agenda-start-day "-d")
                                    (org-agenda-todo-ignore-deadlines nil)))
                        (tags-todo "+important"
                              ((org-agenda-overriding-header "Tâches Importantes à Venir")
                               (org-tags-match-list-sublevels nil)))
                        (tags-todo "-important"
                                   ((org-agenda-overriding-header "Tâches de Travail")
                                      (org-agenda-category-filter-preset '("-Habitudes"))
                                    (org-agenda-sorting-strategy
                                     '(todo-state-down priority-down))))
                        (tags "REFILE"
                              ((org-agenda-overriding-header "Tâches à la Représenter")
                               (org-tags-match-list-sublevels nil)))

                        ))))
              )

        (setq  gas/keep-clock-running nil)

        (defvar gas/organisation-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")


        (use-package which-key)

        )
