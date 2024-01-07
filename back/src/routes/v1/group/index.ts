import { FastifyInstance, FastifyRequest } from "fastify";
import DB, { Group } from "../../../database";
import { v4 as uuidv4 } from "uuid";

type RequestGet = FastifyRequest<{}>;

type RequestGetOne = FastifyRequest<{
  Params: {
    id: string;
  };
}>;

type RequestPost = FastifyRequest<{
  Body: {
    name: string;
    description: string;
  };
}>;

type RequestPatch = FastifyRequest<{
  Params: {
    id: string;
  };
  Body: {
    name?: string;
    description?: string;
  };
}>;

type RequestDelete = FastifyRequest<{
  Params: {
    id: string;
  };
}>;

export default function (fastify: FastifyInstance, opts: any, done: any) {
  fastify.get("/group", async (request: RequestGet, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const groups = DB.groups.filter((group) => group.owner === request.user.id);

    reply.send(groups);
  });
  fastify.get("/group/:id", async (request: RequestGetOne, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const group = DB.groups.find(
      (group) =>
        group.id === request.params.id && group.owner === request.user.id
    );

    if (!group) {
      reply.code(404).send({ error: "Group not found" });
      return;
    }

    reply.send(group);
  });
  fastify.post(
    "/group",

    async (request: RequestPost, reply) => {
      if (!(await request.isAuthenticated())) {
        reply.code(401).send({ message: "Unauthorized" });
        return;
      }

      const group = {
        id: uuidv4(),
        ...request.body,
        tasks: [],
        owner: request.user.id,
      } as Group;

      DB.groups.push(group);

      reply.send(group);
    }
  );
  fastify.patch("/group/:id", async (request: RequestPatch, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const group = DB.groups.find(
      (group) =>
        group.id === request.params.id && group.owner === request.user.id
    );

    if (!group) {
      reply.code(404).send({ error: "Group not found" });
      return;
    }

    const updatedGroup = {
      ...group,
      ...request.body,
    };

    DB.groups = DB.groups.map((group) =>
      group.id === request.params.id ? updatedGroup : group
    );

    reply.send(updatedGroup);
  });
  fastify.delete("/group/:id", async (request: RequestDelete, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const group = DB.groups.find(
      (group) =>
        group.id === request.params.id && group.owner === request.user.id
    );

    if (!group) {
      reply.code(404).send({ error: "Group not found" });
      return;
    }

    DB.groups = DB.groups.filter((group) => group.id !== request.params.id);

    reply.send(group);
  });

  done();
}
