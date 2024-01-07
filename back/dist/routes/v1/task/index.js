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
    fastify.get("/task", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const tasks = database_1.default.tasks.filter((task) => task.owner === request.user.id);
        reply.send(tasks);
    }));
    fastify.get("/task/:id", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const task = database_1.default.tasks.find((task) => task.id === request.params.id && task.owner === request.user.id);
        if (!task) {
            reply.code(404).send({ error: "Task not found" });
            return;
        }
        reply.send(task);
    }));
    fastify.post("/task/:group", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const group = database_1.default.groups.find((group) => group.id === request.params.group && group.owner === request.user.id);
        if (!group) {
            reply.code(404).send({ error: "Group not found" });
            return;
        }
        const newTask = Object.assign(Object.assign({ id: (0, uuid_1.v4)() }, request.body), { status: "TODO", completed: false, owner: request.user.id });
        database_1.default.tasks.push(newTask);
        database_1.default.groups = database_1.default.groups.map((group) => group.id === request.params.group
            ? Object.assign(Object.assign({}, group), { tasks: [...group.tasks, newTask] }) : group);
        reply.send(newTask);
    }));
    fastify.patch("/task/:id", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const task = database_1.default.tasks.find((task) => task.id === request.params.id && task.owner === request.user.id);
        if (!task) {
            reply.code(404).send({ error: "Task not found" });
            return;
        }
        const updatedTask = Object.assign(Object.assign({}, task), request.body);
        database_1.default.tasks = database_1.default.tasks.map((task) => task.id === request.params.id ? updatedTask : task);
        database_1.default.groups = database_1.default.groups.map((group) => {
            if (group.owner === request.user.id) {
                return Object.assign(Object.assign({}, group), { tasks: group.tasks.map((task) => task.id === request.params.id ? updatedTask : task) });
            }
            return group;
        });
        reply.send(updatedTask);
    }));
    fastify.delete("/task", (request, reply) => __awaiter(this, void 0, void 0, function* () {
        if (!(yield request.isAuthenticated())) {
            reply.code(401).send({ message: "Unauthorized" });
            return;
        }
        const task = database_1.default.tasks.find((task) => task.id === request.params.id && task.owner === request.user.id);
        if (!task) {
            reply.code(404).send({ error: "Task not found" });
            return;
        }
        database_1.default.tasks = database_1.default.tasks.filter((task) => task.id !== request.params.id);
        database_1.default.groups = database_1.default.groups.map((group) => {
            if (group.owner === request.user.id) {
                return Object.assign(Object.assign({}, group), { tasks: group.tasks.filter((task) => task.id !== request.params.id) });
            }
            return group;
        });
        reply.send(task);
    }));
    done();
}
exports.default = default_1;
