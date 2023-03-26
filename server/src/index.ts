import { app } from "./app";

const initServer = () => {
  app.listen(5000, () => {
    console.log("server running on port 5000");
  });
};

initServer();
