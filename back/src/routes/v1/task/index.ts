import { FastifyInstance, FastifyRequest } from "fastify";

type RequestGet = FastifyRequest<{}>;

type RequestGetOne = FastifyRequest<{
  Params: {
    id: string;
  };
}>;

type RequestPost = FastifyRequest<{
  Body: {
    name: string;
  };
}>;

type RequestPatch = FastifyRequest<{
  Params: {
    id: string;
  };
  Body: {
    name?: string;
    status?: "TODO" | "DOING" | "DONE";
    completed?: boolean;
  };
}>;

type RequestDelete = FastifyRequest<{
  Params: {
    id: string;
  };
}>;

export default async function (fastify: FastifyInstance, opts: any, done: any) {
  fastify.get("/task", async (request: RequestGet, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const tasks = await fastify.prisma.task.findMany({
      where: { ownerId: request.user.id },
    });

    reply.send(tasks);
  });

  fastify.get("/task/:id", async (request: RequestGetOne, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const task = await fastify.prisma.task.findFirst({
      where: {
        id: request.params.id,
        ownerId: request.user.id,
      },
    });

    if (!task) {
      reply.code(404).send({ error: "Task not found" });
      return;
    }

    reply.send(task);
  });

  fastify.post("/task", async (request: RequestPost, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const newTask = await fastify.prisma.task.create({
      data: {
        name: request.body.name,
        status: "TODO",
        completed: false,
        ownerId: request.user.id,
      },
    });

    reply.send(newTask);
  });

  fastify.patch("/task/:id", async (request: RequestPatch, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const updatedTask = await fastify.prisma.task.update({
      where: {
        id: request.params.id,
        ownerId: request.user.id,
      },
      data: request.body,
    });

    reply.send(updatedTask);
  });

  fastify.delete("/task/:id", async (request: RequestDelete, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const deletedTask = await fastify.prisma.task.delete({
      where: {
        id: request.params.id,
        ownerId: request.user.id,
      },
    });

    reply.send(deletedTask);
  });

  done();
}
