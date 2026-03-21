# Variables
COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data

# Règle par défaut
all: 
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	docker-compose -f $(COMPOSE_FILE) up -d --build

# Arrêter les conteneurs (sans les supprimer)
stop:
	docker-compose -f $(COMPOSE_FILE) stop

# Arrêter et supprimer les conteneurs et les réseaux
down:
	docker-compose -f $(COMPOSE_FILE) down

# Nettoyage classique (conteneurs, réseaux et images non utilisés)
clean: down
	docker system prune -a -f

# Grand nettoyage (clean + suppression des volumes Docker et des données locales)
fclean: clean
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@docker volume prune -f

# Tout recommencer à zéro
re: fclean all

# Indique que ces mots ne sont pas des fichiers
.PHONY: all stop down clean fclean re