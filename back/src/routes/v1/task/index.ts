import { FastifyInstance, FastifyRequest } from "fastify";
import DB, { Task } from "../../../database";
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

export default function (fastify: FastifyInstance, opts: any, done: any) {
  fastify.get("/task", async (request: RequestGet, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const tasks = DB.tasks.filter((task) => task.owner === request.user.id);

    reply.send(tasks);
  });
  fastify.get("/task/:id", async (request: RequestGetOne, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const task = DB.tasks.find(
      (task) => task.id === request.params.id && task.owner === request.user.id
    );

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

    const newTask = {
      id: uuidv4(),
      ...request.body,
      status: "TODO",
      completed: false,
      owner: request.user.id,
    } as Task;

    DB.tasks.push(newTask);

    reply.send(newTask);
  });
  fastify.patch("/task/:id", async (request: RequestPatch, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const task = DB.tasks.find(
      (task) => task.id === request.params.id && task.owner === request.user.id
    );

    if (!task) {
      reply.code(404).send({ error: "Task not found" });
      return;
    }

    const updatedTask = {
      ...task,
      ...request.body,
    };

    DB.tasks = DB.tasks.map((task) =>
      task.id === request.params.id ? updatedTask : task
    );

    reply.send(updatedTask);
  });
  fastify.delete("/task/:id", async (request: RequestDelete, reply) => {
    if (!(await request.isAuthenticated())) {
      reply.code(401).send({ message: "Unauthorized" });
      return;
    }

    const task = DB.tasks.find(
      (task) => task.id === request.params.id && task.owner === request.user.id
    );

    if (!task) {
      reply.code(404).send({ error: "Task not found" });
      return;
    }

    DB.tasks = DB.tasks.filter((task) => task.id !== request.params.id);

    reply.send(task);
  });

  done();
}
