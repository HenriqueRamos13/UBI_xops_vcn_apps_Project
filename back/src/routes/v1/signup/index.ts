import { FastifyInstance, FastifyRequest } from "fastify";
import * as bcrypt from "bcryptjs";
import DB from "../../../database";
import { v4 as uuidv4 } from "uuid";

type Request = FastifyRequest<{
  Body: {
    email: string;
    password: string;
    name: string;
    gender: string;
  };
}>;

export default function (fastify: FastifyInstance, opts: any, done: any) {
  fastify.post("/signup", async (request: Request, reply) => {
    const { email, password, name } = request.body;

    const userExists = DB.users.find((user) => user.email === email);

    if (userExists) {
      reply.code(400).send({ message: "User already exists" });
    }

    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(password, salt);

    const user = DB.users.push({
      id: uuidv4(),
      email,
      password: hash,
      name,
      createdAt: new Date(),
    });

    if (user) {
      reply.code(200).send({ message: "User created successfully" });
    } else {
      reply.code(400).send({ message: "User not created" });
    }
  });

  done();
}
