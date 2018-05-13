"use strict";
// https://developers.google.com/web/updates/2017/04/headless-chrome
// https://github.com/GoogleChrome/puppeteer
// https://medium.com/@bluepnume/learn-about-promises-before-you-start-using-async-await-eb148164a9c8
// https://blog.risingstack.com/mastering-async-await-in-nodejs/
// https://hackernoon.com/6-reasons-why-javascripts-async-await-blows-promises-away-tutorial-c7ec10518dd9
// https://github.com/caolan/async#parallel
// https://github.com/petkaantonov/bluebird

const puppeteer = require('puppeteer');

const Browser = async(cb) => {
  const browser = await puppeteer.launch({headless: true, args: ['--no-sandbox']})
  try {
    await cb(browser)
  }
  finally {
    browser.close()
  }
}

(async() => {
  await Browser(async browser => console.log("Browser Version: " + await browser.version()))
  console.log("page test")
  await Browser(async browser => {
    const actions = []
    const cleanups = []
    try {
      actions.push((async() =>{
        let page = await browser.newPage()
        try {
          await page.goto('https://www.google.com/', {waitUntil: ['load', 'networkidle2']}) // other options: domcontentloaded, networkidle0 ; https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagegotourl-options
          console.log("got page")
        }
        finally {
          cleanups.push(page.close())
        }
      })())
    }
    finally {
      try {
        await Promise.all(actions)
      }
      finally {
        await Promise.all(cleanups) // todo use bluebird and cancel the browser cleanup rather than wait
      }
    }
  })
})();
