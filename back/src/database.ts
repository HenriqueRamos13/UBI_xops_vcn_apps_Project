export type User = {
  id: string;
  name: string;
  email: string;
  password: string;
};

export type Task = {
  id: string;
  name: string;
  status: "TODO" | "DOING" | "DONE";
  completed: boolean;
  owner: User;
};

export type Db = {
  users: User[];
  tasks: Task[];
};

const DB: Db = {
  users: [],
  tasks: [],
};

export default DB;
