import { FastifyInstance, FastifyRequest } from "fastify";
import * as bcrypt from "bcryptjs";

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

    const userExists = await fastify.prisma.user.findFirst({
      where: {
        email,
      },
    });

    if (userExists) {
      reply.code(400).send({ message: "User already exists" });
    }

    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(password, salt);

    const user = await fastify.prisma.user.create({
      data: {
        email,
        password: hash,
        name,
      },
    });

    if (user) {
      reply.code(200).send({ message: "User created successfully" });
    } else {
      reply.code(400).send({ message: "User not created" });
    }
  });

  done();
}
