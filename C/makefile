CFLAGS= -W -Wall -g -c -I -02
LDFLAGS=-L

all: analyseMIDI


analyseMIDI : analyseMIDI.o
	gcc -o $@  $^  $(LFLAGS)-lm
	rm -f *.o

analyseMIDI.o : analyseMIDI.c
	gcc $(CFLAGS) analyseMIDI.c -lm
clean :
	@rm *.o
cleaner : clean
	@rm $(EXEC)
# # pour écrire un comentaire dans un makefile

# cible:dependances
#		commandes


# $@     Le nom de la cible
# $<     Le nom de la première dépendance
# $^     La liste des dépendances
# $*     Le nom du fichier sans suffixe

#noms de variable standard donnés dans le makefile:

# CC compilateur (compiler collection)
# CFLAGS regroupe les options de compilation
# LD éditeur de lien (link loader)
# LDFLAGS regroupant les options de l'édition de liens.
# EXEC le nom des exécutables à générer
