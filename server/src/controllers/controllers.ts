import { Request, Response } from "express";
import axios from "axios";
import { getState, setState } from "../utils/state";
import { Repository } from "../utils/repo";
import { selectElement } from "../utils/select";

export class Controller {
  static main = (_req: Request, res: Response): void => {
    res.status(200);
    res.send("it works");
  };
  static refresh = async (_req: Request, res: Response): Promise<void> => {
    const gitRequest = await axios.get("https://github.com/trending");
    const body = await gitRequest.data;
    setState(body);
    res.status(200);
    res.send({ status: 200 });
  };
  static getRandomRepo = async (req: Request, res: Response): Promise<void> => {
    const $ = await getState();
    const alreadySent = req.body.alreadySent;
    let i: number = Math.floor(Math.random() * 23);
    while (alreadySent.find((index: number) => i === index) != undefined) {
      i = Math.floor(Math.random() * 23);
    }

    const titleAndAuthor = selectElement(
      $,
      `#js-pjax-container > div.position-relative.container-lg.p-responsive.pt-6 > div > div:nth-child(2) > article:nth-child(${
        i + 1
      }) > h1 > a`
    );
    const repo: Repository = {
      author: titleAndAuthor.substring(0, titleAndAuthor.indexOf(" /")).trim(),
      title: titleAndAuthor
        .substring(titleAndAuthor.indexOf("      "), titleAndAuthor.length)
        .trim(),
      description: selectElement(
        $,
        `#js-pjax-container > div.position-relative.container-lg.p-responsive.pt-6 > div > div:nth-child(2) > article:nth-child(${
          i + 1
        }) > p`
      ),
      language: selectElement(
        $,
        `#js-pjax-container > div.position-relative.container-lg.p-responsive.pt-6 > div > div:nth-child(2) > article:nth-child(${
          i + 1
        }) > div.f6.color-text-secondary.mt-2 > span.d-inline-block.ml-0.mr-3 > span:nth-child(2)`
      ),
      stars: selectElement(
        $,
        `#js-pjax-container > div.position-relative.container-lg.p-responsive.pt-6 > div > div:nth-child(2) > article:nth-child(${
          i + 1
        }) > div.f6.color-text-secondary.mt-2 > a:nth-child(2)`
      ),
      contributors: selectElement(
        $,
        `#js-pjax-container > div.position-relative.container-lg.p-responsive.pt-6 > div > div:nth-child(2) > article:nth-child(${
          i + 1
        }) > div.f6.color-text-secondary.mt-2 > a:nth-child(3)`
      ),
    };

    res.status(200);
    res.send(repo);
  };
}
