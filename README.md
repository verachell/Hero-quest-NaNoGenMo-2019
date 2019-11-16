# Present-day Hero's Quest NaNoGenMo 2019
Generates a novel with a hero's quest plot, set in the present day.

## Overview
This program generates a "novel" of greater than 50,000 words in text format. The novel has a Hero's Quest plot where the  main character has the goal of finding an item.

The user is prompted for desired filename for output. The program requires no other information from the user. The choice of words used in the novel has an element of randomness, so subsequent runs of the program will result in different novels.

__Credits:__ Many of the phrases used are taken from a Project Gutenberg book: [Fifteen Thousand Useful Phrases, by Grenville Kleiser](http://www.gutenberg.org/ebooks/18362). Fifth Edition, Funk & Wagnalls Company, New York and London, 1919.

Additional phrases were necessary for the plot besides those from the book above, therefore I created additional phrases on my own. To ensure correct attribution, phrases from the book mentioned above by Grenville Kleiser are in files whose name begins with "GUTENBERG_". Phrases I made up are in files whose name begins with "VERACHELL_", or are hard-coded into the algorithm.

Instructions for installation are shown further below.

## Features

The program has the following features:

- Defined end point. The story has an ending where the plot is resolved by the hero finding the  item. This includes the hero delivering the item to a specified location.

- Simile references. At the start of the story, a simile that refers to a concrete image is randomly selected from a list, e.g. "... the poppy burned like a crimson ember." The image referred to in the simile ("crimson ember") is then used throughout the story, e.g. "Out of the corner of my eye, I perceived a crimson ember."

- Story mood switch. In the opening paragraph, there is a sentence describing the atmosphere of the story at the start and at the end, e.g. "My hunt started with thoughtful silence and ended with egoistic sentiment." In the first half of the story, sentences occur that use the first mood ("thoughtful silence"); while in the second half of the story those mood descriptors switch to using the second mood ("egoistic sentiment"). 

- Backstory of main character. Each run of the novel generates a backstory that has an element of randomness. (e.g. "I'm female with short hair and brown eyes."
 "I'm short and I like to do jigsaw puzzles."
 "Normally I work as a photographer, but fortunately my new job doesn't start until next week." ... etc). During story generation, a backstory sentence is added into the novel if there are still unused backstory sentences remaining. Typically the backstory is short so you will see it more in the earlier chapters; by the end the backstory has typically been all used up, so you won't see it there.

- Mannerisms. This is separate to backstory. The main character is assigned a mannerism at the start of the story (e.g. "cracked my knuckles"). Sentences containing that mannerism occur throughout the story (e.g. "Absentmindedly, I cracked my knuckles while continuing on my way.")

- Increase in the level of paranoia during the story. To create a sense of suspense, the main character feels more paranoid as the story goes along. This is done by an increase in the frequency of sentences that indicate paranoia, e.g. "I could not help but wonder whether I was being trailed."

## Installation
 This program is written in Common Lisp and may be compiled and run on any ANSI-compliant implementation of Common Lisp. 

To run the Present-day Hero's Quest program, you will need to install Common Lisp as described below if you do not already have Lisp on your machine. Common Lisp is very easy to install and does not require any set-up; it "just works". 

The Present-day Hero's Quest program was developed using Steelbank Common Lisp (SBCL) on Linux. Present-day Hero's Quest has been tested on a different implementation of Lisp: CLISP on Linux. It was also tested on SBCL on Windows 10; it works on all of the above. Present-day Hero's Quest remains untested on Mac.

### Installing Lisp
While any ANSI-compliant implementation of Common Lisp would be appropriate, for the sake of example I'll give detailed instructions here for installing SBCL. This is simply because SBCL is available for a large range of OS's and chip architectures. 

#### For Linux
- SBCL is available for installation via the Synaptic Package Manager. 
- Or if you do not have Synaptic, then go to the [SBCL website](http://www.sbcl.org/platform-table.html) and download the appropriate binary from there.

#### For Windows
Go to the [SBCL website](http://www.sbcl.org/platform-table.html) and download the Windows binary (it'll be the Windows AMD64). Run the download, and it will install via Install Wizard. NOTE: Do __NOT__ pick the default install location suggested by Install Wizard as it’ll then install Lisp in a location of your PC where admin read-write perms are required; therefore you won’t be able to compile files or do anything where you need to write to a file. Instead, when in the Install Wizard, choose your install location to be somewhere where you have read-write perms that don’t require admin privileges (e.g. a subdirectory within your documents folder). There is probably a way to set things up to get around that, but it wasn’t obvious to me how to do it. So to make sure it works out of the box, install somewhere in your user directory. That issue is specific to Windows and is not a problem if you are installing for Linux via Synaptic.

#### For other operating systems
Follow instructions on the [SBCL website](http://www.sbcl.org/platform-table.html).

### Installing and running Present-day Hero's Quest
Simply download the Present-day Hero’s Quest files from this repository. For Linux place it in any working directory; for Windows place it in the directory where the sbcl executable is located.

Regardless of what machine you are on, you should at this point have a `herosquest.lisp` file in your working directory (plus README and license), and a `data` subdirectory containing a bunch of data files in .txt format.

#### Compiling and running (super-easy!)
Get Lisp started:

- For Linux, at your normal shell command-line prompt, type:

    `sbcl`

- For Windows, click on the sbcl executable

No matter which OS you are on, you should now have a star-shaped prompt. You are now in the Lisp environment, ready to compile and run.

To compile, type the following command, including parentheses, quotation marks, etc.

`(compile-file "herosquest.lisp")`

You may see a long list of functions it’s compiled; that’s normal. If you look in your directory, you should see that a new file has been created by sbcl during this process, called `herosquest.fasl`

To run the program, type

`(load "herosquest.fasl")`

That’s all there is to it. The program will run. You will be prompted for the file name for output.
