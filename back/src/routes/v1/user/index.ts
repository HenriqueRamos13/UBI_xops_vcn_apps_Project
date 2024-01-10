import { FastifyInstance, FastifyRequest } from "fastify";

type RequestGet = FastifyRequest<{}>;

type RequestGetOne = FastifyRequest<{
  Params: {
    id: string;
  };
}>;

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

export default async function (fastify: FastifyInstance, opts: any, done: any) {
  fastify.get("/user", async (request: RequestGet, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const users = await fastify.prisma.user.findMany({
      where: { id: request.user.id },
    });

    reply.send(users);
  });

  fastify.get("/user/:id", async (request: RequestGetOne, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const user = await fastify.prisma.user.findFirst({
      where: {
        id: request.params.id,
      },
    });

    if (!user) {
      reply.code(404).send({ error: "User not found" });
      return;
    }

    reply.send(user);
  });

  fastify.patch("/user/:id", async (request: RequestPatch, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const updatedUser = await fastify.prisma.user.update({
      where: {
        id: request.params.id,
      },
      data: request.body,
    });

    reply.send(updatedUser);
  });

  fastify.delete("/user/:id", async (request: RequestDelete, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const deletedUser = await fastify.prisma.user.delete({
      where: {
        id: request.params.id,
      },
    });

    reply.send(deletedUser);
  });

  done();
}
