import { readFileSync, writeFileSync } from "fs";
import { CheerioAPI, load } from "cheerio";

export const setState = async (body: string): Promise<void> => {
  await writeFileSync("res/body.html", body);
};

export const getState = async (): Promise<CheerioAPI> => {
  const body = await readFileSync("res/body.html");
  return load(body);
};
