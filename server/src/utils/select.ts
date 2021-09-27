import { CheerioAPI } from "cheerio";

export const selectElement = ($: CheerioAPI, selector: string): string => {
  return $(selector).first().text().trim();
};
