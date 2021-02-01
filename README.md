#Shell Script to Perl Converter

To compile the codes, i write this command lines in terminal.

cd Desktop (if the files are in desktop)
lex proje.l
yacc -d project.y
gcc lex.yy.c y.tab.c -o project -lfl
./project example1.sh outputfile.pl

To see errors in examplesyntaxerror.sh files 

cd Desktop (if the files are in desktop)
lex proje.l
yacc -d project.y
gcc lex.yy.c y.tab.c -o project -lfl
./project examplesyntaxerror1.sh outputfile2.pl

---

## Contributors
- Hilal Turfullu <turfullu.hilal@gmail.com>

---

## License & Copyright
© Hilal Turfullu, Yeditepe University

Licensed under the [MIT LICENSE](LICENSE).


