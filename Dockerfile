FROM steamcmd/steamcmd:latest as steamcmd

ARG APP_ID=1690800
ARG DEPOT_ID=1690802
ARG MANIFEST_ID=0
ARG APP_DIR="/satisfactory"

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

RUN useradd --uid "$UID" --user-group --shell /sbin/nologin "$USER"

WORKDIR $APP_DIR
COPY --from=steamcmd "/root/.steam/steamcmd/linux32/steamapps/content/app_$APP_ID/depot_$DEPOT_ID/" .

USER $USER
ENTRYPOINT ["./FactoryServer.sh"]