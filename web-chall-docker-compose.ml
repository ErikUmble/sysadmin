include:
  - path: /home/fairgame-chals/web/100/docker-compose.yml
  - path: /home/fairgame-chals/web/200/docker-compose.yml
  - path: /home/fairgame-chals/web/300/docker-compose.yml
  - path: /home/fairgame-chals/web/400/docker-compose.yml
  - path: /home/fairgame-chals/web/500/docker-compose.yml
  - path: /home/rpisec-neuctf-collab-chals/Challenges/Web/keycodes/docker-compose.yml
  - path: /home/rpisec-neuctf-collab-chals/Challenges/Web/recipe_book/docker-compose.yml
  - path: /home/HackRPIsec/sql_fun/docker-compose.yml
  - path: /home/HackRPIsec/scrubstagram/docker-compose.yml
  - path: /home/HackRPIsec/InspectElement/docker-compose.yml
  - path: /home/HackRPIsec/guided_download/docker-compose.yml
  - path: /home/HackRPIsec/forced_download/docker-compose.yml
  - path: /home/HackRPIsec/dangerous_greeting/docker-compose.yml
  - path: /home/HackRPIsec/XSS/docker-compose.yml
  - path: /home/HackRPIsec/Robots/docker-compose.yml


services:
  ##
  # Reverse Proxy (not a chall)
  ##
  reverse_proxy:
    image: nginx:latest
    container_name: nginx_reverse_proxy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/reverse_proxy.conf:/etc/nginx/nginx.conf
    networks:
      - reverse_proxy_net


networks:
  reverse_proxy_net:
    name: reverse_proxy_net