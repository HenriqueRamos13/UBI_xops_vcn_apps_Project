"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const database_1 = __importDefault(require("../../../database"));
function default_1(fastify, opts, done) {
    fastify.get("/user", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const users = database_1.default.users.filter((user) => user.id === request.user.id);
        reply.send(users);
    }));
    fastify.get("/user/:id", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const user = database_1.default.users.find((user) => user.id === request.params.id && user.id === request.user.id);
        if (!user) {
            reply.code(404).send({ error: "User not found" });
            return;
        }
        reply.send(user);
    }));
    //   fastify.post("/user", async (request: RequestPost, reply) => {});
    fastify.patch("/user/:id", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const user = database_1.default.users.find((user) => user.id === request.params.id && user.id === request.user.id);
        if (!user) {
            reply.code(404).send({ error: "User not found" });
            return;
        }
        const updatedUser = Object.assign(Object.assign({}, user), request.body);
        database_1.default.users = database_1.default.users.map((user) => user.id === request.params.id ? updatedUser : user);
        reply.send(updatedUser);
    }));
    fastify.delete("/user", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const user = database_1.default.users.find((user) => user.id === request.params.id && user.id === request.user.id);
        if (!user) {
            reply.code(404).send({ error: "User not found" });
            return;
        }
        database_1.default.users = database_1.default.users.filter((user) => user.id !== request.params.id);
        reply.send(user);
    }));
    done();
}
exports.default = default_1;
