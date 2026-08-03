#!/bin/bash

echo "Début des vérifications..."

# Vérifie si le fichier existe
if [ -f "./app/index.html" ]; then
    echo "Succès : Le fichier index.html est bien présent."
    echo "Fin des vérifications."
    exit 0
else
    echo "Erreur : Le fichier index.html est introuvable."
    exit 1
fi