FROM steamcmd/steamcmd:latest as steamcmd

ARG APP_ID=1690800
ARG DEPOT_ID=1690802
ARG MANIFEST_ID=0

RUN steamcmd \
        +login anonymous \
        +download_depot "$APP_ID" "$DEPOT_ID" "$MANIFEST_ID" \
        +quit

FROM ubuntu:20.04

ARG APP_ID=1690800
ARG DEPOT_ID=1690802
ARG MANIFEST_ID=0
ARG APP_DIR="/satisfactory"
ARG USER="steam"
ARG UID="1294"

LABEL APP_ID="$APP_ID" \
      DEPOT_ID="$DEPOT_ID" \
      MANIFEST_ID="$MANIFEST_ID"

RUN useradd -m --uid "$UID" --user-group --shell /sbin/nologin "$USER"
RUN mkdir /app && chown -R $UID:$UID /app
RUN mkdir $APP_DIR && chown -R $UID:$UID $APP_DIR

WORKDIR /app
COPY --from=steamcmd --chown=$UID:$UID "/root/.steam/steamcmd/linux32/steamapps/content/app_$APP_ID/depot_$DEPOT_ID/" .

USER $USER
RUN mkdir -p "/home/steam/.config/Epic/FactoryGame/Saved" && \
    mkdir -p "/app/FactoryGame/Saved" && \
    ln -sf "$APP_DIR/SaveGames" "/home/steam/.config/Epic/FactoryGame/Saved/SaveGames" && \
    ln -sf "$APP_DIR/Config" "/app/FactoryGame/Saved/Config" && \
    ln -sf "$APP_DIR/Logs" "/app/FactoryGame/Saved/Logs"

ENTRYPOINT ["./FactoryServer.sh"]