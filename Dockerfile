# A mix of https://github.com/vercel/next.js/tree/canary/examples/with-docker
# and https://dev.to/chrsgrrtt/dockerising-a-next-js-project-1ck5
# with comments for clarity :)

# start with a node 16 image (alpine is the slimmed down minimal version)
FROM node:16-alpine AS dev

# add a compatibility lib
# RUN apk add --no-cache libc6-compat

# install dependencies
WORKDIR /app
COPY package.json package-lock.json .
RUN npm ci

# copy all app files
COPY . .

# default command is dev server
EXPOSE 3000
CMD ["npm", "run", "dev"]

# create a new image to build for production
FROM node:16-alpine AS build
WORKDIR /app
ENV NODE_ENV=production

COPY --from=dev /app .
RUN npm run build && npm install --production --ignore-scripts --prefer-offline

# Production image, only transfer necessary built files to run app
FROM node:16-alpine AS production
WORKDIR /app
ENV NODE_ENV production

# create a non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# You only need to copy next.config.js if you are NOT using the default configuration
# COPY --from=build /app/next.config.js ./
COPY --from=build /app/public ./public
COPY --from=build --chown=nextjs:nodejs /app/.next ./.next
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json

USER nextjs

EXPOSE 3000

# disable anonymous telemetry collected by nextjs
ENV NEXT_TELEMETRY_DISABLED 1

CMD ["npm", "run", "start"]
