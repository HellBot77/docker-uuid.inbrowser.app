FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/uuid.inbrowser.app.git && \
    cd uuid.inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /uuid.inbrowser.app
COPY --from=base /git/uuid.inbrowser.app .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm run build

FROM pierrezemb/gostatic

COPY --from=build /uuid.inbrowser.app/dist /srv/http
EXPOSE 8043