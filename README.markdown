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

 - Remove the "startSide" temporary filter logic, and replace it with
   code that only examines the variables of type "color".

 - Try the fixed template in the VLC blog post and look in its
   comments for more things to do. Move those comments here in and
   make a task list. Remove the comments and replace them with a
   commented-out link to the github that has been created.


