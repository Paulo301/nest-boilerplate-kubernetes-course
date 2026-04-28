FROM node:20.17.0 as build

WORKDIR /user/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the NestJS application
RUN npm run build

# Delete the dev dependencies
RUN npm prune --production

FROM node:20.17.0-alpine3.20

WORKDIR /user/src/app

COPY --from=build /user/src/app/package*.json ./
COPY --from=build /user/src/app/dist ./dist
COPY --from=build /user/src/app/node_modules ./node_modules

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD ["npm", "run", "start:prod"]