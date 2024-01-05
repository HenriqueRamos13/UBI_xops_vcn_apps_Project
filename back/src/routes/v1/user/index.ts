import { FastifyInstance, FastifyRequest } from "fastify";
import DB from "../../../database";

type RequestGet = FastifyRequest<{}>;

type RequestGetOne = FastifyRequest<{
  Params: {
    id: string;
  };
}>;

type RequestPost = FastifyRequest<{}>;

type RequestPatch = FastifyRequest<{
  Params: {
    id: string;
  };
  Body: {
    email?: string;
    password?: string;
    name?: string;
  };
}>;

type RequestDelete = FastifyRequest<{
  Params: {
    id: string;
  };
}>;

export default function (fastify: FastifyInstance, opts: any, done: any) {
  fastify.get("/user", async (request: RequestGet, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const users = DB.users.filter((user) => user.id === request.user.id);

    reply.send(users);
  });
  fastify.get("/user/:id", async (request: RequestGetOne, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const user = DB.users.find(
      (user) => user.id === request.params.id && user.id === request.user.id
    );

    if (!user) {
      reply.code(404).send({ error: "User not found" });
      return;
    }

    reply.send(user);
  });
  //   fastify.post("/user", async (request: RequestPost, reply) => {});
  fastify.patch("/user/:id", async (request: RequestPatch, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const user = DB.users.find(
      (user) => user.id === request.params.id && user.id === request.user.id
    );

    if (!user) {
      reply.code(404).send({ error: "User not found" });
      return;
    }

    const updatedUser = {
      ...user,
      ...request.body,
    };

    DB.users = DB.users.map((user) =>
      user.id === request.params.id ? updatedUser : user
    );

    reply.send(updatedUser);
  });
  fastify.delete("/user", async (request: RequestDelete, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const user = DB.users.find(
      (user) => user.id === request.params.id && user.id === request.user.id
    );

    if (!user) {
      reply.code(404).send({ error: "User not found" });
      return;
    }

    DB.users = DB.users.filter((user) => user.id !== request.params.id);

    reply.send(user);
  });

  done();
}
