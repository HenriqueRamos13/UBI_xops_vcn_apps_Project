export type User = {
  id: string;
  name: string;
  email: string;
  password: string;
  createdAt: Date;
};

export type Task = {
  id: string;
  name: string;
  description?: string;
  status: "TODO" | "DOING" | "DONE";
  completed: boolean;
  owner: User;
  createdAt: Date;
};

export type Group = {
  id: string;
  name: string;
  description: string;
  tasks: Task[];
  owner: User;
  createdAt: Date;
};

export type Db = {
  users: User[];
  tasks: Task[];
  groups: Group[];
};

const DB: Db = {
  users: [],
  tasks: [],
  groups: [],
};

export default DB;
