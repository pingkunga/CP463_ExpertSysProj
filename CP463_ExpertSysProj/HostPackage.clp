
;;;======================================================
;;;
;;;   Host Package Expert System
;;;
;;;======================================================

;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))
   
(deftemplate state-list
   (slot current)
   (multislot sequence))
  
(deffacts startup
   (state-list))
   
;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner ""
  =>
  (assert (UI-state (display WelcomeMessage)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************
;This defrule in fix!!!
(defrule determine-manage ""
   (logical (start))
   =>
   (assert (UI-state (display manageQ)
                     (relation-asserted manageANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;MAY_GOING_TO_RULE1_CONCLUSION
(defrule determine-heavyUse ""
   (logical (manageANS Yes))
   =>
   (assert (UI-state (display heavyUseQ)
                     (relation-asserted heavyUseANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;MAY_GOING_TO_RULE2&3&4_CONCLUSION
(defrule determine-vps ""
   (logical (heavyUseANS No))
   =>
   (assert (UI-state (display vpsQ)
                     (relation-asserted vpsANS)
                     (response No)
                     (valid-answers Win-Server CentOS Other))))

;This defrule in fix!!!
;MAY_GOING_TO_RULE5&6_CONCLUSION
(defrule determine-lang ""
   (logical (manageANS No))
   =>
   (assert (UI-state (display langQ)
                     (relation-asserted langANS)
                     (response No)
                     (valid-answers ASP,ASP.NET PHP OTHER))))

;This defrule in fix!!!
(defrule determine-staticWeb ""
   (logical (langANS PHP))
   =>
   (assert (UI-state (display staticWebQ)
                     (relation-asserted staticWebANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
(defrule determine-haveDomainName ""
   (logical (staticWebANS Yes))
   =>
   (assert (UI-state (display haveDomainNameQ)
                     (relation-asserted haveDomainNameANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;haveDomainNameANS is No
;MAY_GOING_TO_RULE7_CONCLUSION
(defrule determine-freeDomainRegis ""
   (logical (haveDomainNameANS No))
   =>
   (assert (UI-state (display freeDomainRegisQ)
                     (relation-asserted freeDomainRegisANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;MAY_GOING_TO_RULE8_CONCLUSION
(defrule determine-bandwidth ""
   (logical (freeDomainRegisANS Yes))
   =>
   (assert (UI-state (display bandwidthQ)
                     (relation-asserted bandwidthANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;MAY_GOING_TO_RULE9&10_CONCLUSION
(defrule determine-threeGBspace ""
   (logical (bandwidthANS Yes))
   =>
   (assert (UI-state (display threeGBspaceQ)
                     (relation-asserted threeGBspaceANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;haveDomainNameANS is Yes
;MAY_GOING_TO_RULE11_CONCLUSION
(defrule determine-bandwidth1 ""
   (logical (haveDomainNameANS Yes))
   =>
   (assert (UI-state (display bandwidthQ)
                     (relation-asserted bandwidthANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;MAY_GOING_TO_RULE12&13_CONCLUSION
(defrule determine-threeGBspace1 ""
   (logical (bandwidthANS Yes))
   =>
   (assert (UI-state (display threeGBspaceQ)
                     (relation-asserted threeGBspaceANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;MAY_GOING_TO_RULE14_CONCLUSION
(defrule determine-simpleUsage ""
   (logical (staticWebANS No))
   =>
   (assert (UI-state (display simpleUsageQ)
                     (relation-asserted simpleUsageANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;MAY_GOING_TO_RULE15_CONCLUSION
(defrule determine-eCommerce ""
   (logical (simpleUsageANS No))
   =>
   (assert (UI-state (display eCommerceQ)
                     (relation-asserted eCommerceANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;MAY_GOING_TO_RULE16_CONCLUSION
(defrule determine-bigCompany ""
   (logical (eCommerceANS No))
   =>
   (assert (UI-state (display bigCompanyQ)
                     (relation-asserted bigCompanyANS)
                     (response No)
                     (valid-answers Yes No))))

;This defrule in fix!!!
;MAY_GOING_TO_RULE17&18_CONCLUSION
(defrule determine-dedicateIP ""
   (logical (bigCompanyANS Yes))
   =>
   (assert (UI-state (display dedicateIPQ)
                     (relation-asserted dedicateIPANS)
                     (response No)
                     (valid-answers Yes No))))

;;;****************
;;;* PACKAGE RULES *
;;;****************
;RULE1: DEDICATE SERVER PACKAGE
;manageANS IS YES &&
;heavyUseANS IS YES
(defrule dedicate-server-conclusions ""
   (logical (heavyUseANS Yes))
   =>
   (assert (UI-state (display dedicateServerCon)
                     (state final))))

;RULE2: VPS WINDOWS PACKAGE
;manageANS IS YES &&
;heavyUseANS IS NO &&
;vpsANS is Win-Server
(defrule vpsMS-server-conclusions ""
   (logical (vpsANS Win-Server))
   =>
   (assert (UI-state (display vpsMSCon)
                     (state final))))

;RULE3: VPS LINUX PACKAGE
;manageANS IS YES &&
;heavyUseANS IS NO &&
;vpsANS is CentOS
(defrule vpsLinux-server-conclusions ""
   (logical (vpsANS CentOS))
   =>
   (assert (UI-state (display vpsLinuxCon)
                     (state final))))

;RULE4: NO VPS PACKAGE
;manageANS IS YES &&
;heavyUseANS IS NO &&
;vpsANS is Other
(defrule vpsOther-server-conclusions ""
   (logical (vpsANS Other))
   =>
   (assert (UI-state (display noCon)
                     (state final))))

;RULE5: NO SUITIBLE PACKAGE 
;manageANS IS NO &&
;langANS IS ASP,ASP.NET
(defrule no-conclusions ""
   (logical (langANS ASP,ASP.NET))
   =>
   (assert (UI-state (display noCon)
                     (state final))))

;RULE6: NO SUITIBLE PACKAGE 
;manageANS IS NO &&
;langANS IS OTHER
(defrule no1-conclusions ""
   (logical (langANS OTHER))
   =>
   (assert (UI-state (display noCon)
                     (state final))))

;RULE7: BASIC PACKAGE
;manageANS IS NO &&
;langANS IS YES &&
;staticWebANS IS YES &&
;haveDomainNameANS IS NO &&
;freeDomainRegisANS IS NO
(defrule basic-conclusions ""
   (logical (freeDomainRegisANS No))
   =>
   (assert (UI-state (display basicCon)
                     (state final))))

;RULE8&11: STANDARD PACKAGE
;manageANS IS NO &&
;langANS IS YES &&
;staticWebANS IS YES &&
;haveDomainNameANS IS NO &&
;---(RULE10 haveDomainNameANS IS YES)---
;freeDomainRegisANS IS YES &&
;bandwidthANS IS NO 
(defrule standard-conclusions ""
   (logical (bandwidthANS No))
   =>
   (assert (UI-state (display standardCon)
                     (state final))))

;RULE9&12: ADAVANCE PACKAGE
;manageANS IS NO &&
;langANS IS YES &&
;staticWebANS IS YES &&
;haveDomainNameANS IS NO &&
;---(RULE11 haveDomainNameANS IS YES)---
;freeDomainRegisANS IS YES &&
;bandwidthANS IS YES &&
;threeGBspaceANS IS YES
(defrule advance-conclusions ""
   (logical (threeGBspaceANS Yes))
   =>
   (assert (UI-state (display advanceCon)
                     (state final))))

;RULE10&13: STANDARD PACKAGE
;manageANS IS NO &&
;langANS IS YES &&
;staticWebANS IS YES &&
;haveDomainNameANS IS NO &&
;---(RULE12 haveDomainNameANS IS YES)---
;freeDomainRegisANS IS YES &&
;bandwidthANS IS YES &&
;threeGBspaceANS IS No
(defrule standard1-conclusions ""
   (logical (threeGBspaceANS No))
   =>
   (assert (UI-state (display standardCon)
                     (state final))))

;RULE14: STANDARD PACKAGE
;manageANS IS NO &&
;langANS IS YES &&
;staticWebANS IS No &&
;simpleUsageANS IS Yes 
(defrule standard2-conclusions ""
   (logical (simpleUsageANS Yes))
   =>
   (assert (UI-state (display standardCon)
                     (state final))))

;RULE15: ADVANCE PACKAGE
;manageANS IS NO &&
;langANS IS YES &&
;staticWebANS IS No &&
;simpleUsageANS IS No &&
;eCommerceANS IS YES
(defrule advance1-conclusions ""
   (logical (eCommerceANS Yes))
   =>
   (assert (UI-state (display advanceCon)
                     (state final))))

;RULE16: PROFESSIONAL PACKAGE
;manageANS IS NO &&
;langANS IS YES &&
;staticWebANS IS No &&
;simpleUsageANS IS No &&
;eCommerceANS IS No &&
;bigCompanyANS IS No
(defrule professional-conclusions ""
   (logical (bigCompanyANS No))
   =>
   (assert (UI-state (display professionalCon)
                     (state final))))

;RULE17: BUSINESS PRO PACKAGE
;manageANS IS NO &&
;langANS IS YES &&
;staticWebANS IS No &&
;simpleUsageANS IS No &&
;eCommerceANS IS No &&
;bigCompanyANS IS No &&
;dedicateIPANS IS No
(defrule businessPro-conclusions ""
   (logical (dedicateIPANS No))
   =>
   (assert (UI-state (display businessProCon)
                     (state final))))

;RULE18: UNTIMATE PACKAGE
;manageANS IS NO &&
;langANS IS YES &&
;staticWebANS IS No &&
;simpleUsageANS IS No &&
;eCommerceANS IS No &&
;bigCompanyANS IS No &&
;dedicateIPANS IS Yes
(defrule unitimate-conclusions ""
   (logical (dedicateIPANS Yes))
   =>
   (assert (UI-state (display untimateCon)
                     (state final))))

;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************
;salience = priority
(defrule ask-question
   (declare (salience 5))
   (UI-state (id ?id))
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
   =>
   (modify ?f (current ?id)
              (sequence ?id ?s))
   (halt))

(defrule handle-next-no-change-none-middle-of-chain
   (declare (salience 10))
   ?f1 <- (next ?id)
   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))               
   =>
   (retract ?f1)
   (modify ?f2 (current ?nid))
   (halt))

(defrule handle-next-response-none-end-of-chain
   (declare (salience 10))
   ?f <- (next ?id)
   (state-list (sequence ?id $?))
   (UI-state (id ?id)
             (relation-asserted ?relation))        
   =>
   (retract ?f)
   (assert (add-response ?id)))   

(defrule handle-next-no-change-middle-of-chain
   (declare (salience 10))
   ?f1 <- (next ?id ?response)
   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
   (UI-state (id ?id) (response ?response))
   =>
   (retract ?f1)
   (modify ?f2 (current ?nid))
   (halt))

(defrule handle-next-change-middle-of-chain
   (declare (salience 10))
   (next ?id ?response)
   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
   (UI-state (id ?id) (response ~?response))
   ?f2 <- (UI-state (id ?nid))
   =>   
   (modify ?f1 (sequence ?b ?id ?e))
   (retract ?f2))
   
(defrule handle-next-response-end-of-chain
   (declare (salience 10))
   ?f1 <- (next ?id ?response)
   (state-list (sequence ?id $?))
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))          
   =>
   (retract ?f1)
   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
   (assert (add-response ?id ?response)))   

(defrule handle-add-response
   (declare (salience 10))
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   ?f1 <- (add-response ?id ?response)           
   =>
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   (retract ?f1))   

(defrule handle-add-response-none
   (declare (salience 10))
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   ?f1 <- (add-response ?id)           
   =>
   (str-assert (str-cat "(" ?relation ")"))
   (retract ?f1))   

(defrule handle-prev
   (declare (salience 10)) 
   ?f1 <- (prev ?id)
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))           
   =>
   (retract ?f1)
   (modify ?f2 (current ?p))
   (halt))
   
