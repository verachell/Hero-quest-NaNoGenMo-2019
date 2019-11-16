;;; Present-day Hero's Quest
;;; Copyright (C) 2019 Veronique Chellgren
;;; This free software is licensed under the GNU General Public License v 3.0. This software comes with ABSOLUTELY NO WARRANTY. You are welcome to redistribute this software under certain conditions. See license file for details.
;;
;; This program generates a "novel" of greater than 50,000 words in text format. The novel has a Hero's Quest plot where the  main character has the goal of finding an item.
;; The user is prompted for desired filename for output. The program requires no other information from the user. The choice of words used in the novel has an element of randomness, so subsequent runs of the program will result in different novels.
;;;
;;; CREDITS: Many of the phrases used are taken from a Project Gutenberg book: Fifteen Thousand Useful Phrases, by Grenville Kleiser. Fifth Edition, Funk & Wagnalls Company, New York and London, 1919.
;;
;;; This program is written in Common Lisp and may be compiled and run on any ANSI-compliant implementation of Common Lisp. SteelBank Common Lisp (SBCL) was the implementation used in the development of this program.
;;;  For more details about features and installation, see README file.
;;
(defparameter *file-error-p* nil)
(defparameter *missing-files* ())
(defparameter *min-words* 50000)
(defparameter *halfway* (floor *min-words* 2))
(defparameter *mood-switched* NIL)
(defparameter *end-condition-satisfied* NIL)
(defparameter *no-clue-ending* NIL)
(defparameter *new-random-state* (make-random-state t))
(defparameter *break-frequency* 20) ;; how often line breaks occur, on a scale of 0 (as little as possible) to 100 (whenever possible)
(defparameter *item-name-all* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *item-desc-all* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *story-mood-all* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *motivation-all* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *motivation-sentences* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *striving-all* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *traits-all* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *oddness-all* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *mood-sentences* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *item-reminders* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *smell-sentences* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *smells* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *sound-sentences* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *sounds* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *emotion-sentences* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *emotions* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *literary-expressions* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *misc-phrases* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *prepositions-of* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *prepositions-into* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *prepositions-by* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *scenery-sentences* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *scenery* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *similes-all* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *simile-sentences* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *places-all* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *clues-all-something-of* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *clues-all-something* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *paranoia* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *clue-whole* "")
(defparameter *convo-all* (make-array 1 :fill-pointer 0 :adjustable t))
(defparameter *curr-convo* ())
(defparameter *item-name* "")
(defparameter *item-desc* "")
(defparameter *whole-item* "")
(defparameter *mood-start* "")
(defparameter *mood-end* "")
(defparameter *curr-mood* "")
(defparameter *motivation* "")
(defparameter *mannerism* "")
(defparameter *simile* "")
(defparameter *simile-object* "")
(defparameter *backstory* ())
(defparameter *asked-item* NIL)
(defparameter *received-clue* NIL)
(defparameter *whole-clue* "")
(defparameter *final-place* "")
(defparameter *gender-pronoun* #(((manwoman . "man")(heshe . "he")(hisher . "his")(himher . "him"))((manwoman . "woman")(heshe . "she")(hisher . "her")(himher . "her"))))
(defparameter *waysofwalking* #("approached" "walked up to me" "came toward me" "strolled my way" "strode in my direction"))
(defparameter *askaboutitem* #("I am seeking a _" "Do you know of a _?" "I am on a quest for _" "Would you have any information about a _?" "I'm looking for a _" "What do you know about a _?" "Do the words _ mean anything to you?" "Where might I find a _?" "Are you able to tell me about a _?"))
(defparameter *getting-nowhere* #("I could see we were getting nowhere" "This wasn't as helpful as I'd hoped" "I had hoped for some more definite information" "We seemed to be talking at cross-purposes"))
(defparameter *clue-sentences* #("What you are seeking may be found in the _" "You need to search for the object you desire at the _" "Consider going to the _ to locate what you are searching for" "It's not easy to find what you're looking for. Try the _" "I heard a rumor that the thing you are searching for may be found at the _" "I have not seen the item you are seeking myself, but my friend saw one in the _" "It's possible that what you are searching for is at the _" "Go to the _, I have once heard mention of the item you seek there"))
(defparameter *clue-comments* #("Hmm. The _! That sounded interesting to me." "Ah. The _. That seemed significant somehow." "The _ was mentioned. Intriguing." "Wow! The _. How curious." "So - the _. That was thought-provoking."))
(defparameter *clue-pondering* #("I pondered what could be meant by the _." "Giving careful consideration to the meaning of _, I continued walking." "I racked my brains. What on earth could the _ be?" "If only a more direct answer had been given to me! I puzzled on the meaning of _." "No matter how much I thought of the phrase '_', I remained puzzled." "I wished with vehemence that I knew what was meant by the _." "What place corresponded to the _, I wondered?" "I wished people would speak more plainly! I wondered what the _ was."))
(defparameter *parted-ways* #("and we each went our own way" "and we parted ways" "and we went our separate ways" "and we each carried on with what we were doing" "and we each continued our separate journeys"))
(defparameter *directions* #("north" "south" "east" "west" "toward my left" "toward my right" "forward"))
(defparameter *epiphanies* #("Suddenly I had an epiphany." "Of course!" "It came to me all at once." "I realized where to go!" "My mind, which had been working on this question, finally came up with a solution." "All of a sudden, I knew what to do." "I had a sudden realization." "Everything became clear."))
(defparameter *meanings* #("could only mean" "had to correspond to" "had to be" "ought to equate to" "must refer to" "must with certainty be"))
(defparameter *break-time-yes* #("I decided it was time to rest and have some sustenance." "Hungry, I thought it would be best to eat a meal." "Beyond weary, I wanted to rest and eat." "Not only was I tired, but also hungry." "A rest and a meal seemed like a good idea at this point." "My feet were tired and it was time to take a break and eat."))
(defparameter *go-eat* #("As exhausted as I was, I quickly made my way to" "I went to" "I headed toward" "Encouraged, I found my way to" "I was glad I didn't have to go too far. I soon got to"))
(defparameter *break-places* #("a restaurant" "a fast food place to get a burger" "a fried chicken restaurant" "a sushi bar" "a pub" "an Italian restaurant"))
(defparameter *continuings* #("I looked forward to continuing my _ afterward." "I knew I would be eager to resume my _ subsequently." "I hoped I would have renewed zeal for my _ after." "A sense of renewed energy was certain to give a new zest to my _." "I knew the refreshments would help invigorate me for my _."))
(defparameter *title-helper* #("quest" "hunt" "journey" "search"))
(defparameter *began-synonyms* #("began" "started" "commenced" "embarked on"))
(defparameter *explanation-helper-left* #("Only once I had the _ " "If I could get the _" "The good news was that by finding the _, "))
(defparameter *explanation-helper-right* #("could I _." ", it would be possible to _." "I would _."))
(defparameter *delivery-all* #("There was one catch though - I had to deliver the item to the _." "However, finding it wasn't enough: I also had to deliver the item to the _." "Once I found it, I would need to deliver the item to the _." "There was one extra task though, and that was to deliver the item to the _ after I found it."))
(defparameter *prepositions-helper* #("I resolved to " "It was time to " "I vowed to " "Now was the moment to " "I decided to " "The hour was upon me to "))
(defparameter *mannerisms-all* #("ran my fingers through my hair" "rubbed the tips of my fingers together" "cracked my knuckles" "took my pencil and paper out and started doodling" "tilted my head in thought" "crossed my arms" "clasped my hands behind my back" "started pacing"))
(defparameter *mannerisms-sentences* #("I _." "While contemplating the current situation, I absentmindedly _." "Looking around, I _." "I _ as I gave thought to the situation in which I found myself." "As I speculated on how I could succeed in my quest, I _." "I _ as I mused on the best way to proceed." "Absentmindedly, I _ while continuing on my way."))
(defparameter *walked-synonyms* #("strode" "walked" "strolled" "hiked" "moved" "trekked" "marched"))
(defparameter *not-found-all* #("Unfortunately, I did not find the" "Despite looking very carefully, I could not uncover the" "Sadly, I was unable to locate the" "Although I had made a very thorough search, I did not discover the" "Reluctantly, I had to admit that I just wasn't able to find the"))
(defparameter *action-helper* #("probed" "dug" "searched" "looked" "hunted" "poked around"))
(defparameter *proximity-helper* #("near" "in" "next to" "below" "inside"))
(defparameter *answers-all* #("Yes" "No" "Maybe" "It's difficult to say" "By all means" "Under no circumstance" "I wish I knew!"))
(defparameter *place-desc* #("smallest" "biggest" "newest" "oldest"))
(defparameter *now-phrases* #("Now I needed" "It was time" "The time had come" "Next I had"))
(defparameter *where-to-go* #("I knew where I needed to go. " "I was familiar with where to go. " "I knew which direction I should go. " "I knew the general area of where to go. "))
(defparameter *elated-synonyms* #("elated" "thrilled" "ecstatic" "overjoyed" "filled with joy" "so happy" "exultant" "jubilant"))
(defparameter *walking-minutes* #("five" "ten" "fifteen" "twenty" "twenty-five" "thirty"))
(defparameter *the-end* #("Finally, it was possible to" "Now I was able to" "Thankfully, I could now" "I was relieved that now I could"))
;; begin backstory variables
(defparameter *eye-helper* #("blue" "green" "brown" "gray" "hazel"))
(defparameter *hairlength-helper* #("short" "medium length" "long"))
(defparameter *height-helper* #("short" "medium height" "tall"))
(defparameter *gender-helper* #("male" "female"))
(defparameter *hobbies-helper* #("paint" "run" "watch TV" "cook gourmet meals" "play board games" "play tennis" "practice beatboxing" "broadcast amateur radio" "do jigsaw puzzles" "create videos" "work out at the gym"))
(defparameter *occupation-helper* #("airplane mechanic" "electronic engineer" "game developer" "sales clerk" "rare book collector" "chef" "hydroelectric dam operator" "architect" "photographer" "videographer" "deli worker" "surveyor" "daycare worker" "pet shop employee" "spy" "social worker" "substitute teacher" "therapist" "tile setter"))
(defparameter *occupation-break-helper* #("my workplace was closed" "I was able to take some vacation days" "I have three days before my shift starts again" "my new job doesn't start until next week"))
(defparameter *likes-helper* #("spring flowers" "watching football" "baking cookies" "playing chess" "my friends" "my family" "gardening"))
(defparameter *dislikes-helper* #("politics" "eating broccoli" "raking leaves" "being on hold on the phone" "playing Monopoly" "mean people" "people who think the party only starts when they arrive" "pessimists" "nihilism" "the color magenta" "nightmares"))
(defparameter *childhood-experience-helper* #("broke my arm climbing a tree" "got in trouble with my parents for riding too far from home on my bicycle" "placed second in a running race, but was sad because I really wanted to win" "ran away from home, only it didn't work because my parents found me really quickly" "ate too many apples and threw up" "my friends and I tried to form a band, but we only played the drums, violin and trumpet so it was hard to decide what music to play"))
(defparameter *last-week-helper* #("going to my job as normal" "deciding which new movie I wanted to see" "going out to the bar with my friends after work" "practicing basketball with a friend" "catching up with family I hadn't seen in awhile" "eating at my favorite Indian restaurant" "going for a jog" "trying to figure out who I should vote for in the next elections" "cooking and eating dinner" "playing video games"))
(defparameter *friend-name-helper* #("Sasha" "Natalie" "Jim" "Blake" "Amy" "Jenna" "Eric" "John" "Gorden" "Sienna" "Victor" "Lena" "Riemann" "Aaron" "Ariana"))
(defparameter *friend-trait-helper* #("always up for a new adventure" "as crazy as a coot, but fun to be around" "unorthodox, but very patient" "always optimistic and upbeat" "thoughtful and kind" "highly efficient and organized" "my best friend" "one of the nicest people I know" "late to everything, but has a heart of gold"))
(defparameter *backstory-defs* '((("I'm _" *gender-helper*)(" with _ hair" *hairlength-helper*)(" and _ eyes." *eye-helper*))(("I'm _" *height-helper*)(" and I like to _." *hobbies-helper*))(("Normally I work as a _" *occupation-helper*)(", but fortunately _." *occupation-break-helper*))(("I wanted to call up my friend _, but what would I say? How could I explain this situation?" *friend-name-helper*))(("I found it hard to believe that just last week I was _." *last-week-helper*))(("To improve my mood, I thought about one of my favorite things: _." *likes-helper*))(("For some reason, I started contemplating one of my major dislikes: _." *dislikes-helper*))(("Deep in thought, I began reminiscing about the time in my childhood when I _." *childhood-experience-helper*))(("I began wishing my friend _ was here," *friend-name-helper*)(" who is _." *friend-trait-helper*))(("When this is all over, I look forward to _." *last-week-helper*))))
;; end backstory variables
(defparameter *title* "")
(defparameter *outfilename* "")
(defparameter *novel* ())
(defparameter *currentpara* ())
(defparameter *currentchapter* 1)
(defparameter *section* '((oddness . 40)(striving . 50)(backstory . 60)(moods . 40)(motive-remind . 40)(item-remind . 40)(smell . 40)(sound . 40)(emotion . 40)(literary-expression . 90)(literary-preposition . 90)(misc-phrase . 75)(preposition-trait . 85)(scenery . 100)(simile-image . 35)(paranoia . 0)(mannerism . 20)))
(defparameter *aimless-wandering* '((walking . 100)(abstr-prep . 90)(backstory . 20)(striving . 30)(desc-walking . 90)))
;;
;; end of all variable declarations
;;

;; functions
(defun print-copyright-and-info ()
  (princ "Present-day Hero's Quest")(terpri)
  (princ "Copyright \(C\) 2019 Veronique Chellgren")(terpri)
  (princ "This program comes with ABSOLUTELY NO WARRANTY.")(terpri)
  (princ "This is free software licensed under the GNU General Public License v3.0,")(terpri)
  (princ "and you are welcome to redistribute it under certain conditions.")(terpri) 
  (princ "See license file for details.")(terpri))

(defun load-in (datafilename thevector)
  ;; loads each line from a file into an entry in an extendable vector
  (let ((in-dir NIL)(in-pathname NIL)(final-path NIL))
    (setf in-dir (make-pathname :directory '(:relative "data")))
    (setf in-pathname (make-pathname :type "txt" :defaults datafilename))
    (setf final-path (merge-pathnames in-pathname in-dir))
    (with-open-file (instream final-path :if-does-not-exist nil)
      (if instream
	  (loop for line = (read-line instream nil)
	     while (and line (string/= "" line)) do
	       (vector-push-extend line thevector))
	  (progn (setf *file-error-p* t)(push datafilename *missing-files*))))))

(defun upcase-start (thestring)
  ;; converts first character of a string to uppercase
  (string-upcase thestring :start 0 :end 1))

(defun downcase-start (thestring)
  ;; converts first character of a string to lowercase
  (string-downcase thestring :start 0 :end 1))

(defun select-random (thevector)
  ;; selects a random item from an extendable vector
  ;; this is used heavily here for selecting a random string from a
  ;; vector of strings. However, it is also used to select from vectors of other types.
  (setf *new-random-state* (make-random-state t))
  (elt thevector (random (length thevector) *new-random-state*)))

(defun wordcountsentence (thestring)
  ;; given a single string as input, count the number of words.
  (let ((finalcount 0))
    (if (/= 0 (length thestring))
	(setf finalcount (+ 1 (count #\Space thestring)))
	(setf finalcount 0))
    (eval finalcount)))

(defun wc (thelist)
  ;; returns the word count of the novel
  (let ((totwords 0))
    (dolist (paragraph thelist)
      (dolist (sentences paragraph)
	(when (> (length sentences) 0)(setf totwords (+ totwords (wordcountsentence sentences))))))
    (return-from wc totwords)))

(defun generate-title ()
  (concatenate 'string "The " (select-random *title-helper*) " for the " *whole-item*))

(defun generate-outfilename (title)
  ;; generates the default filename for output of the novel, based on title.
  ;; all lowercase.
  (let ((outfilename title))
    (setf outfilename (substitute #\- #\Space  outfilename))
    (setf outfilename (string-downcase (concatenate 'string outfilename ".txt")))))

(defun generate-start ()
  ;; generates first sentence of novel
  (concatenate 'string "My " (select-random *title-helper*) " started with " *curr-mood* " and ended with " *mood-end* "."))

(defun simile-extract (thestring)
  ;; This function extracts everything after "like" or "as" in a string,
  ;; beginning the search for "like" or "as" from the end of the string.
  ;; If not present, returns an empty string.
  ;; If the word is present at the end of the string,
  ;;  to return a result same as not present.
  (let ((wordas 0)(wordlike 0))
    (setf wordas (search " as " thestring :from-end t))
    (if (not wordas)(setf wordas 0)(if (>= (+ wordas 4)(length thestring))(setf wordas 0)))
    (setf wordlike (search " like " thestring :from-end t))
    (if (not wordlike)(setf wordlike 0)(if (>= (+ wordlike 6)(length thestring))(setf wordlike 0)))
    (cond ((= 0 wordas wordlike)(eval ""))
	  ((> wordas wordlike)(subseq thestring (+ wordas 4)))
	  (t (subseq thestring (+ wordlike 6))))))

(defun generate-level1-sentence (thestring thereplacement)
  ;; given a string containing the placeholder character '_' this replaces
  ;; it with thereplacement, also a string. A direct madlib-style sentence.
  (let ((thepos 0)(lefthalf "")(righthalf ""))
    (setf thepos (position #\_ thestring :test #'equal))
    (setf lefthalf (subseq thestring 0 thepos))
    (setf righthalf (subseq thestring (+ thepos 1)))
    (concatenate 'string lefthalf thereplacement righthalf)))

(defun generate-backstory ()
  ;; generates main character's backstory for subsequent drip-feeding into the novel
  (let ((currstr "")(tempstr "")(thebackstory ()))
    (dolist (x *backstory-defs*)
      (setf currstr "")
      (dolist (y x)
	(setf tempstr (generate-level1-sentence (eval (first y))(select-random (eval (second y)))))
	(setf currstr (concatenate 'string currstr tempstr)))
      (push currstr thebackstory))
    (terpri)
    (setf thebackstory (nreverse thebackstory))
    (return-from generate-backstory thebackstory)))

(defun generate-explanation ()
  ;; for the start of the novel - links the motivation to the item being sought
  (let ((num 0)(lefthalf "")(righthalf ""))
    (setf num (random (length *explanation-helper-left*)))
    (setf lefthalf (generate-level1-sentence (elt *explanation-helper-left* num) *whole-item*))
    (setf righthalf (generate-level1-sentence (elt *explanation-helper-right* num) *motivation*))
    (concatenate 'string lefthalf righthalf)))

(defun pushpara ()
  ;; pushes the current paragraph to the novel and re-sets
  ;; the para to empty. A couple of otherwise frequently-repeated lines of code
  (when (and (not (equal '("") *currentpara*)) (not (NULL *currentpara*)))
    (push *currentpara* *novel*)
    (setf *currentpara* ())))

(defun pushchapter ()
  ;; makes a chapter entry to the novel and re-sets current para to empty.
  ;; increments the chapter counter.
  (push (concatenate 'string "CHAPTER " (write-to-string *currentchapter*)) *currentpara*)
  (pushpara)
  (incf *currentchapter*))

(defun shuffle (thelist)
  ;; puts a list of strings in random order
  (let ((newlist ())(randnum 0))
    (loop while (not (null thelist)) do
	 (if (= (length thelist) 1)(push (pop thelist) newlist)
	     (progn
	       (setf randnum (random (length thelist) *new-random-state*))
	       (push (nth randnum thelist) newlist)
	       (setf thelist (remove (nth randnum thelist) thelist)))))
    (return-from shuffle newlist)))

(defun test-end-condition ()
  ;; end condition tests true if word-count is above required minimum and
  ;; a clue has been received, OR, if word-count is above twice the required
  ;; minimum (the latter condition is to avoid the possibility of
  ;; endless looping in the rare probability where clues are not received)
  (when (and (> (wc *novel*)(* 2 *min-words*))(not *received-clue*))(setf *no-clue-ending* t))
  (or (and (> (wc *novel*) *min-words*)(eval *received-clue*))(> (wc *novel*)(* 2 *min-words*))))

(defun end-para ()
  (let ((thepara ()))
    ;; if we get to an end condition, with no clue given and no item found,
    ;; force character to look for item and find it before going to the ending.
    (when (eval *no-clue-ending*)
      (push (concatenate 'string "Having had no success from asking others, I finally decided to carefully search at the " (select-random *places-all*) ". I set off in that direction and arrived about twenty-five minutes later. Once there, I made a very careful and thorough search. ") thepara)
      (push (concatenate 'string "My heart leapt. I found a " *item-name* "! And it was indeed " *item-desc* ".") thepara))
    ;; the next bit is common for all endings.
    (push (concatenate 'string (select-random *now-phrases*) " to deliver the " *item-name* " to the " *final-place* ".") thepara)
    (push (paranoia) thepara)
    (push (motive-remind) thepara)
    (push (concatenate 'string (select-random *where-to-go*) "First I " (select-random *walked-synonyms*) " " (select-random *directions*) " and went for about " (select-random *walking-minutes*) " minutes in that direction, then went " (select-random *directions*) ". Finally I arrived at the correct place. I was " (select-random *elated-synonyms*) "!") thepara)
    (push (concatenate 'string "I handed off the " *whole-item* " with a sense of " *curr-mood* ". " (select-random *the-end*) " " *motivation* ".") thepara)))

(defun load-out (thenovel)
  ;; writes the novel out to a file.
  ;; filename defaults to that determined by the program, but
  ;; user may over-ride filename to own choice.
  (let ((userok t)(newfilename "")(temppara ())(totwords 0)(tempsentence ""))
    (setf totwords (wc thenovel))
    (format t "~%The title of the novel is: ")(format t *title*)
    (format t "~%The default filename to write the novel to is: ")(format t "~%")
    (format t *outfilename*)(format t "~%")
    (setf userok (y-or-n-p "Is this filename OK? "))
    (if (not userok)(progn
		      (format *query-io* "~a: "  "Enter desired filename: ")
		      (force-output *query-io*)
		      (setf newfilename (read-line *query-io*))
		      (setf *outfilename* newfilename)))
    (with-open-file (outstream *outfilename* :direction :output :if-exists nil)
      (if outstream (progn
		      (princ "writing novel to file...")
		      (setf thenovel (reverse thenovel))
		      (loop while (> (length thenovel) 0) do
			   (setf temppara (pop thenovel))
			   (setf temppara (remove "" temppara))
			   (setf temppara (remove NIL temppara))
			   (if (= 1 (length temppara))
			       (progn
				 (when (not (NULL temppara))
				   (write-line (first temppara) outstream)
				   (terpri outstream)))
			       (progn
				 (setf temppara (reverse temppara))
				 (loop while (> (length temppara) 0) do
				      (setf tempsentence (pop temppara))
				      (when (string/= "" tempsentence)
					(write-string tempsentence outstream)
					(write-string " " outstream)))			 
				 (terpri outstream)
				 (terpri outstream))))
		      (print totwords)(princ " words written to file.")(terpri))
	  (format t "~%Unable to write novel to file because file already exists")))))

;; START OF THE FUNCTIONS THAT MAKE UP THE BULK OF THE NOVEL

(defun oddness ()
  (select-random *oddness-all*))

(defun striving ()
  (select-random *striving-all*))

(defun moods ()
  (generate-level1-sentence (select-random *mood-sentences*) *curr-mood*))

(defun motive-remind ()
  (generate-level1-sentence (select-random *motivation-sentences*) *motivation*))

(defun item-remind ()
  (generate-level1-sentence (select-random *item-reminders*) *whole-item*))

(defun smell ()
  (generate-level1-sentence (select-random *smell-sentences*) (select-random *smells*)))

(defun sound ()
  (generate-level1-sentence (select-random *sound-sentences*) (select-random *sounds*)))

(defun mannerism ()
  (generate-level1-sentence (select-random *mannerisms-sentences*) *mannerism*))

(defun backstory ()
  (if (not (null *backstory*))
      (pop *backstory*)
      (return-from backstory "")))

(defun emotion ()
  (generate-level1-sentence (select-random *emotion-sentences*) (select-random *emotions*)))

(defun literary-expression ()
  (concatenate 'string (select-random *literary-expressions*) ", " (downcase-start (select-random *literary-expressions*)) "; these things I contemplated as I walked."))

(defun literary-preposition ()
  (concatenate 'string (select-random *prepositions-helper*) (select-random *prepositions-into*) " the " (select-random *prepositions-of*) "."))

(defun misc-phrase ()
  (concatenate 'string "It was " (downcase-start (select-random *misc-phrases*)) ", " (select-random *prepositions-by*) "."))

(defun scenery ()
  (concatenate 'string (generate-level1-sentence (select-random *scenery-sentences*) (select-random *scenery*)) "."))

(defun preposition-trait ()
  (concatenate 'string (upcase-start (select-random *prepositions-by*)) ", I was " (select-random *traits-all*) "."))

(defun simile-image ()
  (generate-level1-sentence (select-random *simile-sentences*) *simile-object*))

(defun paranoia ()
  (select-random *paranoia*))

(defun walking ()
  (let ((trait ""))
    (if (< (random 100 *new-random-state*) 50)(setf trait *curr-mood*)(setf trait (select-random *story-mood-all*)))
    (concatenate 'string "With " trait ", I began walking " (select-random *directions*) ".")))

(defun abstr-prep ()
  (concatenate 'string (upcase-start (select-random *prepositions-by*)) ", things began to " (select-random *prepositions-into*) "."))

(defun desc-walking ()
  (concatenate 'string (upcase-start (select-random *prepositions-by*)) ", I continued walking."))

(defun question-p (thestring)
  (eval (char= #\? (elt thestring (- (length thestring) 1)))))

(defun exclamation-p (thestring)
  (eval (char= #\! (elt thestring (- (length thestring) 1)))))

(defun speech-suffix (thephrase pronoun prevquestion)
  (let ((question NIL)(exclamation NIL)(final-suffix))
    (setf question (question-p thephrase))
    (setf exclamation (exclamation-p thephrase))
    (cond ((and (eval prevquestion)(eval question))(setf final-suffix (concatenate 'string " " pronoun " answered with another question.")))
	  ((eval question)(setf final-suffix (concatenate 'string " " pronoun " asked.")))
	  ((and (not question)(eval prevquestion))(setf final-suffix (concatenate 'string " " pronoun " replied.")))
	  ((eval exclamation)(setf final-suffix (concatenate 'string " " pronoun " exclaimed.")))
	  (t (setf final-suffix (concatenate 'string " " pronoun (select-random #(" said." " said." " said." " said." " remarked." " declared." " said." " insisted." " reflected." " mused." " mentioned."))))))
    (eval final-suffix)))

(defun generate-convo ()
  (let ((finalconvo ())(currlines 0)(correctpronoun ())(gendertalker "")(currtalker "")(othertalker "")(randnum 0)(basicphrase "")(prevquestion NIL)(clue "")(suffix "")(completephrase "")(comma "")(tempstr ""))
    (setf *asked-item* NIL)
    (setf *received-clue* NIL)
    (setf correctpronoun (select-random *gender-pronoun*))
    (setf gendertalker (cdr (assoc 'heshe correctpronoun)))
    ;; other person approaches
    (if (< (random 100 *new-random-state*) 90)(setf tempstr (concatenate 'string " " (upcase-start gendertalker) " appeared " (select-random *traits-all*) "."))(setf tempstr ""))
    (push (concatenate 'string "A " (cdr (assoc 'manwoman correctpronoun)) " " (select-random *waysofwalking*) "." tempstr) finalconvo)
    ;; decide who starts convo
    (setf randnum (random 100 *new-random-state*))
    (if (< 50 randnum)
	(progn (setf currtalker "I")(setf othertalker gendertalker))
	(progn (setf currtalker gendertalker)(setf othertalker "I")))
    ;; start cycles of convo
    (loop while (and (< currlines 10)(not *received-clue*)) do
       ;; if the previous thing was a question, give a chance of selecting randomly an answer.
	 (if (and (eval prevquestion)(< (random 100 *new-random-state*) 60))(setf basicphrase (select-random *answers-all*))
	     ;; if did not wind up randomly selecting an answer, then do normal convo generation
	     (progn
	       ;; if main character's turn, has a high chance of asking about quest item as
	       ;; long as has not been asked already, otherwise talks about something else
	       (if (string-equal currtalker "I")
		   ;; then in the case of the main character's turn
		   (progn
		     (if (and (not *asked-item*)(< (random 100 *new-random-state*) 65))
			 ;; then main character asks about item
			 (progn (setf basicphrase (generate-level1-sentence (select-random *askaboutitem*) *whole-item*))(setf *asked-item* t))
			 ;; else main character says something else
			 (setf basicphrase (select-random *convo-all*))))
		   ;; on the other hand, if it's the other person's turn...
		   (progn
		     ;; other person has a chance of giving a clue if main
		     ;; character has asked about it and has not already been given a clue.
		     (if (and (eval *asked-item*)(< (random 100 *new-random-state*) 40)(not *received-clue*))
			 ;; in the case that the item has been asked about and
			 ;; the other person wishes to give a clue
			 (progn
			   (setf clue (concatenate 'string (select-random *clues-all-something-of*) " of " (select-random *clues-all-something*)))
			   (setf basicphrase (generate-level1-sentence (select-random *clue-sentences*) clue))
			   (setf *received-clue* t))
			 ;; else the other person says something else
			 (progn
			   (setf basicphrase (select-random *convo-all*))))))))
       ;; now whoever is supposed to be currently talking has a phrase assigned
       ;; at this point. Regardless of what the phrase is, it needs a suffix such as "I said"
	 (setf suffix (speech-suffix basicphrase currtalker prevquestion))
	 (if (or (question-p basicphrase)(exclamation-p basicphrase))(setf comma "")(setf comma ","))
	 (if (question-p basicphrase)(setf prevquestion t)(setf prevquestion NIL))
	 (rotatef currtalker othertalker)
       ;; phrase plus suffix needs formatting
	 (setf completephrase (concatenate 'string"\"" basicphrase comma "\"" suffix))
	 (push completephrase finalconvo)
	 (incf currlines))
    ;;; convo cycles now ended
    (if (eval *received-clue*)
	(push (concatenate 'string (generate-level1-sentence (select-random *clue-comments*) clue) " I thanked " (cdr (assoc 'himher correctpronoun)) " " (select-random *parted-ways*) ". " (generate-level1-sentence (select-random *clue-pondering*) clue)) finalconvo)
	(push (concatenate 'string (select-random *getting-nowhere*) ", so I politely bade " (cdr (assoc 'himher correctpronoun)) " farewell.") finalconvo))
    (setf *whole-clue* clue)
    (return-from generate-convo finalconvo)))

(defun clue-actions ()
  ;; if given a clue, go to the place and seek the item
  (let ((actions ())(theplace ""))
    (setf theplace (select-random *places-all*))
    (push (concatenate 'string (select-random *epiphanies*) " The " *whole-clue* " " (select-random *meanings*) " the " theplace ".") actions)
    (push (concatenate 'string (select-random *literary-expressions*) ", I " (select-random *walked-synonyms*) " " (select-random *directions*) ".") actions)
    (push (concatenate 'string "Finally I arrived without mishap other than " (downcase-start (select-random *misc-phrases*)) ".") actions)
    (push (emotion) actions)
    (push (item-remind) actions)
    (push (concatenate 'string "I " (select-random *action-helper*) " " (select-random *proximity-helper*) " the " theplace " for quite some time.") actions)
    (if (not *end-condition-satisfied*)
	(push (concatenate 'string (select-random *not-found-all*) " " *whole-item* ".") actions)
	(push (concatenate 'string "My heart leapt. I found a " *item-name* "! And it was indeed " *item-desc* ".") actions))
    (return-from clue-actions actions)))

(defun rest-eat ()
  ;; main character rests and eats
  (let ((thepara())(tempstr ""))
    (push (select-random *break-time-yes*) thepara)
    (push (concatenate 'string (select-random *go-eat*) " " (select-random *break-places*) " to eat.") thepara)
    (setf tempstr (generate-level1-sentence (select-random *continuings*) (select-random *title-helper*)))
    (push tempstr thepara)
    (return-from rest-eat thepara)))

;; END OF THE FUNCTIONS THAT MAKE UP THE BULK OF THE NOVEL
;; end of all functions

;; START OF THE ACTUAL PROGRAM
;;
;; load data from files
(print-copyright-and-info)
(load-in "VERACHELL_itemname.txt" *item-name-all*)
(load-in "VERACHELL_itemdesc.txt" *item-desc-all*)
(load-in "GUTENBERG_Kleiser_Phrases-SectionI-abridged.txt" *story-mood-all*)
(load-in "VERACHELL_motivation.txt" *motivation-all*)
(load-in "VERACHELL_motivation-sentence.txt" *motivation-sentences*)
(load-in "VERACHELL_striving.txt" *striving-all*)
(load-in "GUTENBERG_Kleiser_Phrases-SectionIII-abridged-traits.txt" *traits-all*)
(load-in "VERACHELL_oddness.txt" *oddness-all*)
(load-in "VERACHELL_moods.txt" *mood-sentences*)
(load-in "VERACHELL_item-reminders.txt" *item-reminders*)
(load-in "VERACHELL_smell-sentence.txt" *smell-sentences*)
(load-in "VERACHELL_smells.txt" *smells*)
(load-in "VERACHELL_sound-sentence.txt" *sound-sentences*)
(load-in "VERACHELL_sounds.txt" *sounds*)
(load-in "VERACHELL_emotion-sentence.txt" *emotion-sentences*)
(load-in "VERACHELL_emotions.txt" *emotions*)
(load-in "GUTENBERG_Kleiser_Phrases-SectionVII-abridged.txt" *literary-expressions*)
(load-in "GUTENBERG_Kleiser_Phrases-SectionXI-abridged.txt" *misc-phrases*)
(load-in "GUTENBERG_Kleiser_Phrases-SectionV-preposition-of-abridged.txt" *prepositions-of*)
(load-in "GUTENBERG_Kleiser_Phrases-SectionV-preposition-into-abridged.txt" *prepositions-into*)
(load-in "GUTENBERG_Kleiser_Phrases-SectionV-preposition-by-abridged.txt" *prepositions-by*)
(load-in "VERACHELL_scenery-sentences.txt" *scenery-sentences*)
(load-in "VERACHELL_scenery.txt" *scenery*)
(load-in "GUTENBERG_Kleiser_Phrases-SectionVIII-similes-abridged.txt" *similes-all*)
(load-in "VERACHELL_simile-desc-sentences.txt" *simile-sentences*)
(load-in "VERACHELL_places.txt" *places-all*)
(load-in "VERACHELL_clue-something-of.txt" *clues-all-something-of*)
(load-in "VERACHELL_clue-something.txt" *clues-all-something*)
(load-in "GUTENBERG_Kleiser_Phrases-SectionIX-conversational-abridged.txt" *convo-all*)
(load-in "VERACHELL_paranoia.txt" *paranoia*)
;; if any files did not load, then stop program
(if (eval *file-error-p*)
    (progn
      (terpri)
      (princ "Error - stopping. One or more data files containing words or phrases are missing.")(terpri)
      (princ "These missing files are expected to be in a subdirectory called: data")(terpri)
      (princ "The missing files are:")(terpri)
      (dolist (m *missing-files*)
	(princ m)(terpri)))
    ;; if files did load, continue
    (progn
      ;; set up novel-specific constants
      (terpri)(princ "Generating novel...")(terpri)
      (setf *item-desc* (select-random *item-desc-all*))
      (setf *item-name* (select-random *item-name-all*))
      (setf *mood-start* (select-random *story-mood-all*))
      (setf *mood-end* (select-random *story-mood-all*))
      (if (string= *mood-start* *mood-end*)(setf *mood-end* (select-random *story-mood-all*)))
      (setf *curr-mood* *mood-start*)
      (setf *motivation* (select-random *motivation-all*))
      (setf *whole-item* (concatenate 'string *item-desc* "\ " *item-name*))
      (setf *final-place* (concatenate 'string (select-random *place-desc*) " " (select-random *places-all*)))
      (setf *mannerism* (select-random *mannerisms-all*))
      (setf *simile* (select-random *similes-all*))
      (setf *simile-object* (simile-extract *simile*))
      ;; if a simile object cannot be found, assign the quest item to it instead
      (if (string= "" *simile-object*)(setf *simile-object* (concatenate 'string "a " *item-name*)))
      ;; now that the simile object has been identified, make the full simile into a sentence for the novel
      (setf *simile* (concatenate 'string "I perceived " (downcase-start *simile*) "."))
      (setf *title* (generate-title))
      (setf *outfilename* (generate-outfilename *title*))
      (setf *backstory* (generate-backstory))
      ;;
      ;; generate the start of the novel
      ;;
      (push *title* *currentpara*)
      (pushpara)
      (pushchapter)
      (push (generate-start) *currentpara*)
      (pushpara)
      (push (generate-level1-sentence (select-random *motivation-sentences*) *motivation*) *currentpara*)
      (push (select-random *striving-all*) *currentpara*)
      (push (generate-explanation) *currentpara*)
      (push (generate-level1-sentence (select-random *delivery-all*) *final-place*) *currentpara*)
      (pushpara)
      (push (concatenate 'string (upcase-start (select-random *traits-all*)) ", I " (select-random *began-synonyms*) " my " (select-random *title-helper*) ".") *currentpara*)
      (push *simile* *currentpara*)
      (pushpara)
      ;;
      ;; generate the middle of the novel
      ;;
      (loop while (not *end-condition-satisfied*) do
	   (pushchapter)
	 ;; first create a pre-conversation section
	   (loop for z from 1 to 3 do
		(setf *section* (shuffle *section*))
		(dolist (x *section*)
		  (when (< (random 100 *new-random-state*)(cdr x))
		    (push (funcall (car x)) *currentpara*))
		  ;; decide randomly whether a line break ought to be introduced
		  (if (< (random 100 *new-random-state*) *break-frequency*)(pushpara)))
		(pushpara)
	      ;; next do conversation, clues, and seeking.
		(setf *curr-convo* (reverse (generate-convo)))
		(dolist (x *curr-convo*)
		  (let ((templist ()))
		    (if (string/= x "")(push x templist))
		    (push templist *novel*)))
		(setf *curr-convo* ())
	      ;; regardless of whether or not clue was received, do some descriptions
	      ;; and walk aimlessly
		(dolist (x *aimless-wandering*)
		  (when (< (random 100 *new-random-state*)(cdr x))
		    (push (funcall (car x)) *currentpara*))
		  (if (and (not (NULL *currentpara*)) (< (random 100 *new-random-state*) *break-frequency*))(pushpara)))
		(pushpara)
	      ;; if clue was received, then decide where to go, then go there.
	      ;; If end condition satisfied, function clue-actions provides ending.
	      ;; if no clue, then if end condition true (via ultra-long word count)
	      ;; then use alternate ending, where character picks a place to go.
	      ;; If not at end condition, move to next cycle.
		(setf *end-condition-satisfied* (test-end-condition))
		(when (eval *received-clue*)
		  (setf *currentpara* (clue-actions))
		  (pushpara)
		  (setf *received-clue* NIL))
	      ;; check if it's halfway through novel, if so, it's time to switch mood to end mood.
		(when (and (not *mood-switched*)(> (wc *novel*) *halfway*))
		  (setf *curr-mood* *mood-end*)(setf *mood-switched* t)
		  (princ "Halfway there...")(terpri))
	      ;; increase the level of paranoia, unless it's already at 100
		(when (< (cdr (assoc 'paranoia *section*)) 100)(incf (cdr (assoc 'paranoia *section*)) 1))
	      until (eval *end-condition-satisfied*)) ;; exit option for loop z 1 to 3
	 ;; If story has not yet ended, main character rests and eats. If story is at an end point,
	 ;; do ending instead.
	   (if (not *end-condition-satisfied*) (setf *currentpara* (rest-eat))
	       (setf *currentpara* (end-para)))
	   (pushpara)
	 until (eval *end-condition-satisfied*)) ;; exit option for outermost loop -  while loop
      (push "THE END" *currentpara*)
      (pushpara)
      (load-out *novel*)))
