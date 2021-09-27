import { Router } from "express";
import { Controller } from "../controllers/controllers";

export const router = Router();

router.get("/", Controller.main);
router.get("/refresh", Controller.refresh);
router.post("/getRandomRepo", Controller.getRandomRepo);
