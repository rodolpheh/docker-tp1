# TP1

[![CircleCI](https://circleci.com/gh/rodolpheh/docker-tp1/tree/master.svg?style=shield)](https://circleci.com/gh/rodolpheh/docker-tp1/tree/master)

- [TP1](#tp1)
  - [Exercice 1](#exercice-1)
  - [Exercice 2](#exercice-2)
  - [Exercice 3](#exercice-3)
  - [Exercice 4](#exercice-4)
  - [Exercice 5](#exercice-5)
  - [Exercice 6](#exercice-6)
  - [Bonus](#bonus)

## Exercice 1

Démarrer l'image de CentOS avec bash:

```bash
docker run -it centos:latest bash
```

Un `cat /etc/centos-release` renvoi `CentOS Linux release 7.6.1810 (Core)`

Pour installer les paquets `wget` et `nc` :

```bash
yum install -y wget nc
```

Lorsqu'on relance un `docker run`, un nouveau container est créé sur l'image qui n'a pas été modifiée par la modification sur le précédent container.

Pour modifier le nom du container, on utilise `docker container rename <name> centos-shell-01`.

Pour retourner dans le container `centos-shell-01`, on utilise `docker start -ai centos-shell-01`.

## Exercice 2

```bash
docker run -d -p 9888:80 nginx:latest
```

On peut alors accèder à la page de test de nginx en se rendant à http://localhost:9888/

Pour se rendre dans le docker démarré : `docker exec -it <name> bash`

On peut vérifier la présence des fichiers de logs avec un `ls /var/log/nginx`. On ne peut par contre pas les lire autrement qu'avec `docker logs <name>`, ceux-ci étant gérés par docker.

Pour supprimer le container, il faut d'abord le stopper :

```bash
docker stop <name>
docker container rm <name>
```

## Exercice 3

Pour créer le répertoire qui contiendra la page web :

```bash
mkdir public_html
cp index.html public_html/
```

On peut alors lancer le container :

```bash
docker run -d -p 80:80 --name isenweb -v `pwd`/public_html:/usr/share/nginx/html nginx:latest
```

Le résultat final est le suivant :

![Résultat](Exercice3.png)

## Exercice 4

```bash
docker volume create nginx-logs
docker run -d -p 7999:80 --name mynginx -v nginx-logs:/var/log/nginx:nocopy nginx:latest
```

On peut lister les fichiers et vérifier leur présence en trouvant d'abord le point de montage du volume avec `docker volume inspect nginx-logs`, on peut alors faire un `sudo ls /var/lib/docker/volumes/nginx-logs/_data`.

```bash
docker run -it --name log-tailer -v nginx-logs:/var/log/nginx:nocopy alpine:latest tail -f /var/log/nginx/access.log
```

À la suite de la commande précédente, le terminal courant affichera tous les nouveaux ajouts aux logs de nginx.

## Exercice 5

```bash
docker build -t my-log-tailer:latest .
docker run -d --name log-tailer -v nginx-logs:/var/log/nginx:nocopy my-log-tailer:latest
```

Si le container `nginx` n'est pas démarré, le log de `log-tailer` affichera "`can't open '/var/log/nginx/access.log': No such file or directory`" avant de quitter. Le cas échéant, on devrait pouvoir voir les logs du container nginx :

```
> docker logs log-tailer
172.17.0.1 - - [25/Mar/2019:09:21:10 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:65.0) Gecko/20100101 Fire
fox/65.0" "-"
```

## Exercice 6

Pour démarrer les containers :

```bash
docker-compose up -d
```

## Bonus

Pour la configuration de CircleCI pour build et push les images automatiquement, j'ai suivi [cet excellent article](https://circleci.com/blog/using-circleci-workflows-to-replicate-docker-hub-automated-builds/).

L'image construite peut être visible [ici](https://cloud.docker.com/repository/docker/rodolpheh/centos).

Le statut du build peut être visible [ici](https://circleci.com/gh/rodolpheh/docker-tp1/tree/master).