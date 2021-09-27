import express from "express";
import { router } from "./routes/routes";
import { json } from "body-parser";
import cors from "cors";

const main = async () => {
  const app = express();
  const port = 3000;

  app.use(json());
  app.use(cors());
  app.use(router);

  app.listen(port, () => {
    console.log(`Application listening at http://localhost:${port}`);
  });
};

main();
