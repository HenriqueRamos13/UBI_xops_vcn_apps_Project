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
const uuid_1 = require("uuid");
function default_1(fastify, opts, done) {
    fastify.get("/group", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const groups = database_1.default.groups.filter((group) => group.owner === request.user.id);
        reply.send(groups);
    }));
    fastify.get("/group/:id", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const group = database_1.default.groups.find((group) => group.id === request.params.id && group.owner === request.user.id);
        if (!group) {
            reply.code(404).send({ error: "Group not found" });
            return;
        }
        reply.send(group);
    }));
    fastify.post("/group", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const group = Object.assign(Object.assign({ id: (0, uuid_1.v4)() }, request.body), { createdAt: new Date(), tasks: [], owner: request.user.id });
        database_1.default.groups.push(group);
        reply.send(group);
    }));
    fastify.patch("/group/:id", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const group = database_1.default.groups.find((group) => group.id === request.params.id && group.owner === request.user.id);
        if (!group) {
            reply.code(404).send({ error: "Group not found" });
            return;
        }
        const updatedGroup = Object.assign(Object.assign({}, group), request.body);
        database_1.default.groups = database_1.default.groups.map((group) => group.id === request.params.id ? updatedGroup : group);
        reply.send(updatedGroup);
    }));
    fastify.delete("/group", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const group = database_1.default.groups.find((group) => group.id === request.params.id && group.owner === request.user.id);
        if (!group) {
            reply.code(404).send({ error: "Group not found" });
            return;
        }
        database_1.default.groups = database_1.default.groups.filter((group) => group.id !== request.params.id);
        reply.send(group);
    }));
    done();
}
exports.default = default_1;
