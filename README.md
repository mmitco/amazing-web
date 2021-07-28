# amazing-web
Web frontend for amazing.com

This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

1. Install [Docker](https://docs.docker.com/get-docker) onto your machine.
2. Run `docker build . -t amazing-web --target dev` to build the dev image.
3. `docker run -p 3000:3000 amazing-web` to run the dev server.

Open [http://localhost:3000](http://localhost:3000) with your browser to see the landing page.

---

You can build the production image using `docker build . -t amazing-web`, which is the default stage.

We will soon have CI that uploads the dev and prod images to DockerHub, so you won't need to build images locally and can skip
straight to `docker run amazing/web` or similar. Look out for that!
