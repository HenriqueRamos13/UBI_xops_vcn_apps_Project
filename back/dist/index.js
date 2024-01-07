"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
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
const dotenv = __importStar(require("dotenv"));
const fastify_1 = __importDefault(require("fastify"));
const pino_1 = __importDefault(require("pino"));
const cors_1 = __importDefault(require("@fastify/cors"));
const cookie_1 = __importDefault(require("@fastify/cookie"));
const rate_limit_1 = __importDefault(require("@fastify/rate-limit"));
dotenv.config();
const serverOpts = process.env.NODE_ENV === "production"
    ? {
        // http2: true,
        // https: {
        //   allowHTTP1: true,
        //   key: fs.readFileSync(path.join(__dirname, "pem/", "key.pem")),
        //   cert: fs.readFileSync(path.join(__dirname, "pem/", "cert.pem")),
        // },
        logger: true,
    }
    : {
        logger: (0, pino_1.default)({
            level: "info",
        }),
    };
const server = (0, fastify_1.default)(serverOpts);
server.register(cors_1.default, {
    // origin:
    //   process.env.NODE_ENV === "production"
    //     ? "https://next-rebel.surge.sh"
    //     : "http://localhost:3000",
    origin: "*",
    preflightContinue: true,
    credentials: true,
});
server.register(cookie_1.default, {
// secret: "my-secret", // for cookies signature
// parseOptions: {
// }     // options for parsing cookies
});
server.register(rate_limit_1.default, {
    max: 10000,
    timeWindow: "1 minute",
});
server.setErrorHandler(function (error, request, reply) {
    if (reply.statusCode === 429) {
        error.message = "You hit the rate limit! Slow down please!";
    }
    reply.send(error);
});
server.register(require("@fastify/jwt"), { secret: process.env.JWT_SECRET });
server.decorateRequest("isAuthenticated", function () {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            yield this.jwtVerify();
            return true;
        }
        catch (err) {
            console.log("ERRO JWT:", err);
            return false;
        }
    });
});
server.register(require("./routes/v1/signup"), { prefix: "/v1" });
server.register(require("./routes/v1/auth"), { prefix: "/v1" });
server.register(require("./routes/v1/user"), { prefix: "/v1" });
server.register(require("./routes/v1/task"), { prefix: "/v1" });
server.register(require("./routes/v1/group"), { prefix: "/v1" });
server.get("/ping", (request, reply) => __awaiter(void 0, void 0, void 0, function* () {
    server.log.info("log message");
    return "pong\n";
}));
const PORT = process.env.PORT ? Number(process.env.PORT) : 3001;
server.listen({ port: PORT, host: "0.0.0.0" }, (err, address) => {
    if (err) {
        server.log.error(err);
        process.exit(1);
    }
    server.log.info(`Server listening at ${address}`);
});
