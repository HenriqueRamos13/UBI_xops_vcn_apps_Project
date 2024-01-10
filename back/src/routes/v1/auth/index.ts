import { FastifyInstance, FastifyRequest } from "fastify";
import * as bcrypt from "bcryptjs";
import * as jwt from "jsonwebtoken";

type Request = FastifyRequest<{
  Body: {
    email: string;
    password: string;
  };
}>;

export default function (fastify: FastifyInstance, opts: any, done: any) {
  fastify.post("/auth", async (request: Request, reply) => {
    const { email, password } = request.body;

    const user = await fastify.prisma.user.findFirst({
      where: {
        email,
      },
    });

    if (user) {
      const isMatch = await bcrypt.compare(password, user.password);

      if (isMatch) {
        const token = await jwt.sign(
          {
            id: user.id,
          },
          process.env.JWT_SECRET!,
          {
            expiresIn: "30d",
          }
        );

        reply.setCookie("token", token, {
          path: "/",
          httpOnly: true,
          secure: process.env.NODE_ENV === "production",
          sameSite: "lax",
        });

        reply.code(200).send({ token, id: user.id });
      } else {
        reply.code(400).send({ message: "Invalid credentials" });
      }
    }
  });

  fastify.get("/auth", async (request: Request, reply) => {
    const token = request.cookies.token;

    if (token) {
      const decoded = jwt.verify(token, process.env.JWT_SECRET!);

      if (!decoded) {
        reply.code(401).send({ message: "Not authorized" });
      }

      const user = await fastify.prisma.user.findFirst({
        where: {
          id: (decoded as jwt.JwtPayload).id,
        },
      });

      if (user) {
        reply.code(200).send({ user, token });
      } else {
        reply.code(404).send({ message: "User not found" });
      }
    } else {
      reply.code(401).send({ message: "Not authorized" });
    }
  });

  fastify.delete("/auth", async (request: Request, reply) => {
    reply.setCookie("token", "", {
      path: "/",
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
    });

    reply.code(200).send({ message: "Logged out" });
  });

  done();
}
