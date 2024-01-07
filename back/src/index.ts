import * as dotenv from "dotenv";
import fastify, { FastifyServerOptions } from "fastify";
import pino from "pino";
import cors from "@fastify/cors";
import type { FastifyCookieOptions } from "@fastify/cookie";
import cookie from "@fastify/cookie";
import rateLimit from "@fastify/rate-limit";
dotenv.config();

const serverOpts: FastifyServerOptions =
  process.env.NODE_ENV === "production"
    ? {
        // http2: true,
        // https: {
        //   allowHTTP1: true,
        //   key: fs.readFileSync(path.join(__dirname, "pem/", "key.pem")),
        //   cert: fs.readFileSync(path.join(__dirname, "pem/", "cert.pem")),
        // },
        logger: true,
      }
    : {
        logger: pino({
          level: "info",
        }),
      };

const server = fastify(serverOpts);

server.register(cors, {
  // origin:
  //   process.env.NODE_ENV === "production"
  //     ? "https://next-rebel.surge.sh"
  //     : "http://localhost:3000",
  origin: "*",
  preflightContinue: true,
  credentials: true,
});

server.register(cookie, {
  // secret: "my-secret", // for cookies signature
  // parseOptions: {
  // }     // options for parsing cookies
} as FastifyCookieOptions);

server.register(rateLimit, {
  max: 10000,
  timeWindow: "1 minute",
});

server.setErrorHandler(function (error, request, reply) {
  if (reply.statusCode === 429) {
    error.message = "You hit the rate limit! Slow down please!";
  }
  reply.send(error);
});

server.register(require("@fastify/jwt"), { secret: process.env.JWT_SECRET });

server.decorateRequest("isAuthenticated", async function () {
  try {
    await this.jwtVerify();

    return true;
  } catch (err) {
    console.log("ERRO JWT:", err);
    return false;
  }
});

server.register(require("./routes/v1/signup"), { prefix: "/v1" });
server.register(require("./routes/v1/auth"), { prefix: "/v1" });
server.register(require("./routes/v1/user"), { prefix: "/v1" });
server.register(require("./routes/v1/task"), { prefix: "/v1" });
server.register(require("./routes/v1/group"), { prefix: "/v1" });

server.get("/ping", async (request, reply) => {
  server.log.info("log message");
  return "pong\n";
});

const PORT: number = process.env.PORT ? Number(process.env.PORT) : 8080;

server.listen({ port: PORT, host: "0.0.0.0" }, (err, address) => {
  if (err) {
    server.log.error(err);
    process.exit(1);
  }
  server.log.info(`Server listening at ${address}`);
});

declare module "fastify" {
  interface FastifyInstance {
    authenticate: () => void;
    jwtVerify: () => Promise<void>;
  }
  interface FastifyRequest {
    someProp: string;
    user: any;
    jwtVerify: () => Promise<void>;
    isAuthenticated: () => Promise<boolean>;
  }
}
