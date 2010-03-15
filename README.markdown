Description
=================

 - Contains utilities for blogging
 - Contains templates and other data in support of a blog

Blogger Template Variable Synchronization
=================

The two .xml files are:

 - `template-stretch-denim-brents-color-scheme.xml` is the one I want to
   modify.

 - `template-Son_of_Moto_Mean_Green_Blogging_Machine_variation.xml` is
   the original template that is too skinny but has the right color
   scheme.

The problem I'm trying to solve is that the two schemes use different
variable names for the different sections. The
`blogger_template_scanner.el` is my attempt at cross-referencing the
sections that they apply to. Eventually, that Elisp code will need to
inspect buffers of both the above .xml files and do the
cross-referencing directly.

I need to make the color scheme in my copy of the "stretch denim"
template to match what I had in my original broken template by looking
at each variable and seeing which ones coincide with the original
template and manually stitching them back in.

I manually canonicalized the "Variable Definitions" sections of the
two .xml files (made all of the line endings and non-significant
whitespace the same for all Variable lines sections) so that I could
use the `blogger_template_scanner.el` file to do the iteration

TODO:
-----

 - DONE: Fix the bug in the "sort" function that doesn't seem to want to
   sort properly. 

 - DONE: Remove the "startSide" temporary filter logic, and replace it with
   code that only examines the variables of type "color".

 - DONE: Factor out the big chunk of lisp s-expression into a
   function, called
   `bg-blogger-util-get-template-variable-references', that takes the
   file name name as a argument, and returns what the current
   expression returns, which is a list of lists whose car is the name
   of the variable and whose cdr is the list of CSS sections that are
   being referenced.

 - DONE: Generalize `bg-blogger-util-get-template-variable-references'
   to check for a specified type of variable, whereas right now it is
   hardcoded to variables of type "color".

 - DONE: Create a new function that calls the new function but with
   both files, and iterates over the result values of both to identify
   the common color usages. For example, find the
   possibly-differently-named color variables that both are specified
   in each of the sections such as, say, "#header". When doing my
   first attempt at this, I discovered something new (to me anyway):

   - It is possible for there to be more than one color variable
     referenced in a given section, e.g.,:
     
       #header {
         margin: 0 2%;
         background-color: $headerBgColor;
         color: $headerTextColor;
         padding: 0;
         font: $headerFont;
         position: relative;
       }

   - It is true in some cases that the color was hardcoded, and not
     referenced by a variable:

       #header-wrapper	{
         background: #8b2 url(http://www.blogblog.com/moto_son/headbotborder.gif) bottom $startSide repeat-x;
         margin: 0 auto;
         padding-top: 0;
         padding-$endSide: 0;
         padding-bottom: 15px;
         padding-$startSide: 0;
         border: 0;
       }

   Given that, my approach is a bit off: I really need to scan all of
   the sections for any of the color attributes (those whose names are
   in front of a ":", such as "background", "background-color", or
   "color"), and use that as the comparison, and then searching the
   variable reference that is involved, versus the other way around.

 - I've now scanned out the data into the form of a multi-level hash
   table keyed by prop name, then selector, then property name and
   value pairs as a list.  After having done that much, I see how the
   tags used in both templates are quite far apart in structure, and I
   will have little choice but to reconcile each color setting by hand
   if I am to make any progress in the short-term goal of making the
   colors correct for the new template.

   But the exercise did result in some useful parsing techniques that
   will be needed for a later project I am considering that is driven
   by the Mozex Firefox extension, whereby changes to the template can
   be sent to Firefox for preview.

 - Try the fixed template in the VLC blog post and look in its
   comments for more things to do. Move those comments here in and
   make a task list. Remove the comments and replace them with a
   commented-out link to the github that has been created.


