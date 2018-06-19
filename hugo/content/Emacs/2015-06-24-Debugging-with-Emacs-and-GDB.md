+++
title = "Debugging with Emacs and GDB"
author = ["Dominik Schrempf"]
description = "Use GDB from withing Emacs to debug source code."
date = 2015-06-24T00:00:00+02:00
keywords = ["GDB", "", "", "", "", ""]
lastmod = 2018-06-18T11:50:00+02:00
type = "post"
draft = false
+++

## Introduction {#introduction}

Erroneous source code can be a nasty issue to tackle.  Print
statements that inform you about the states of variables are handy but
sometimes they are unable to represent the intrinsic structure of the
code.  Debuggers allow you to run your code step by step, display and
watch variables and see what is going on _inside_ another program
while it executes.


## The GNU poject debugger {#the-gnu-poject-debugger}

Here, we will use the [GNU project debugger (GDB)](http://www.gnu.org/software/gdb/), because it is freely
available, very actively developed and can be used on many operating
systems.  It can

-   start your program, specifying anything that might affect its behavior;
-   make your program stop on specified conditions;
-   examine what has happened, when your program has stopped;
-   change things in your program, so you can experiment with correcting
    the effects of one bug and go on to learn about another.


## GDB in Emacs {#gdb-in-emacs}

To debug our program, we will use **Emacs** and **C source code**,
although `gdb` can be used from the command line and can debug many
different languages.

A good overview about debugging in Emacs with GDB can be found in the
[Emacs manual](http://www.gnu.org/software/emacs/manual/html_node/emacs/GDB-Graphical-Interface.html#GDB-Graphical-Interface).

A short step-by-step guide:

-   Open and save a new file `hello.c` with the following contents:

    ```c
    #include <stdio.h>

    int main(int argc, char* argv[]) {
        int i;
        printf("hello world\n");
        for ( i=0;i<10;++i) {
            printf("%d \n",i);
        }
        return 0;
    }
    ```

-   Compile it with `M-x compile`; enter the command `gcc -Wall -g
      hello.c -o hello`.  Usually, it is very helpful to compile your
    source code with debugging flags (e.g., `-g` for `gcc`), so that
    nothing is optimized out by the compiler.
-   Activate the graphical debugging environment with `M-x
      gdb-many-windows`.
-   Start the debugger with `M-x gdb`; enter the command `gdb -i=mi
      hello`.

From withing the Grand Unified Debugger (GUD) buffer, you can run
(`r`) the program to its end or to the first break point, start
(`start`) and run in until the beginning of the main procedure.  You
can execute the program line-by-line (`n`) or step into functions with
`s`.

Breakpoints can be set from withing the source buffer by clicking on
the fringe or with `C-x C-a C-b`.


## Customize GDB {#customize-gdb}

To permanently set the nice GDB user interface layout, put

```lisp
(setq gdb-many-windows t)
```

into your `.emacs` file.  I have also written a function, that
facilitates the starting of the debugger:

```lisp
(defvar gdb-my-history nil "History list for dom-gdb-MYPROG.")
(defun dom-gdb-MYPROG ()
  "Debug MYPROG with `gdb'."
  (interactive)
  (let* ((wd "/path/to/working/directory")
         (pr "/path/to/executable")
         (dt "/path/to/datafile")
         (guess (concat "gdb -i=mi -cd=" wd " --args " pr " -s " dt))
         (arg (read-from-minibuffer "Run gdb (like this): "
                                    guess nil nil 'gdb-my-history)))
    (gdb arg)))
```


## Window management {#window-management}

Upon debugging a program with many source files, GDB displays new
source files in (random?) windows in your Emacs frame.  This is
especially tedious if you use `gdb-many-windows`.  I have written a
function `dom-gdb-restore-windows`, that resets the display and fixes
the window layout:

```lisp
(defun dom-gdb-restore-windows ()
  "Restore GDB session."
  (interactive)
  (if (eq gdb-many-windows t)
      (gdb-restore-windows)
    (dom-gdb-restore-windows-gud-io-and-source)))

(defun dom-gdb-restore-windows-gud-io-and-source ()
  "Restore GUD buffer, IO buffer and source buffer next to each other."
  (interactive)
  ;; Select dedicated GUD buffer.
  (switch-to-buffer gud-comint-buffer)
  (delete-other-windows)
  (set-window-dedicated-p (get-buffer-window) t)
  (when (or gud-last-last-frame gdb-show-main)
    (let ((side-win (split-window nil nil t))
          (bottom-win (split-window)))
      ;; Put source to the right.
      (set-window-buffer
       side-win
       (if gud-last-last-frame
           (gud-find-file (car gud-last-last-frame))
         (gud-find-file gdb-main-file)))
      (setq gdb-source-window side-win)
      ;; Show dedicated IO buffer below.
      (set-window-buffer
       bottom-win
       (gdb-get-buffer-create 'gdb-inferior-io))
      (set-window-dedicated-p bottom-win t))))

(defun dom-gdb-display-source-buffer ()
  "Display gdb source buffer if it is set."
  (interactive)
  (when (or gud-last-last-frame gdb-show-main)
    (switch-to-buffer
     (if gud-last-last-frame
         (gud-find-file (car gud-last-last-frame))
       (gud-find-file gdb-main-file))))
  (delete-other-windows))
```
