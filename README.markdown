Description
=================

 - Contains utilities for blogging
 - Contains templates and other data in support of a blog

Blogger Templates
=================

The .xml template files I have used (or are currently using) in my
Blogger blog are:

 - `template-stretch-denim-brents-color-scheme.xml` contains a similar
    color scheme as in `template-Son_of_Moto_Mean_Green_Blogging_Machine_variation.xml`
    but doesn't suffer from the skinny nature of the latter.

 - `template-Son_of_Moto_Mean_Green_Blogging_Machine_variation.xml` is
   the original template that is too skinny but has the right color
   scheme.

 - `template-simple-josh-peterson-green-color-scheme.xml` is just the
   a saving off of my original Simple template before deciding I
   needed to add syntax highlighting for source code.

 - `template-with-code-syntax-highlighting.xml`
   is the same as
   `template-simple-josh-peterson-green-color-scheme.xml` but with the
   syntax highlighting code added (see
   http://www.craftyfella.com/2010/01/syntax-highlighting-with-blogger-engine.html
   for details). I did not have to do html encoding as his site
   indicated as long as I use the `CDATA` blocks. For example, these
   worked on my blog:

    <script class="brush: js" type="syntaxhighlighter"><![CDATA[
      /**
       * SyntaxHighlighter
       */
      function foo()
      {
          if (counter <= 10)
              return;
          // it works!
      }
    ]]></script>

The Elisp file, `blogger_template_scanner.el`, is a set of utility
functions I used for scanning the CSS parts of the Blogger templates
