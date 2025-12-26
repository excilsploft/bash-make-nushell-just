const axios = require('axios');
const colors = require('colors');

async function getData(service, url) {

  try {
    const response = await axios.get(url);
    const result = response.data;
    const status = result.status;
    switch (status.indicator) {
       case "critical":
            console.log(colors.red(`${service} Status: ${status.description}`));
            break;
       case "major":
            console.log(colors.orange(`${service} Status: ${status.description}`));
            break;
       case "minor":
            console.log(colors.yellow(`${service} Status: ${status.description}`));
            break;
        default:
            console.log(colors.green(`${service} Status: ${status.description}`));
    }
  } catch (error) {
    console.error(colors.red(`${service} Error: ${error.message}`));
  }
}


const urls = {Github: "https://www.githubstatus.com/api/v2/summary.json",
              NPM:  "https://status.npmjs.org/api/v2/summary.json",
              PyPi: "https://status.python.org/api/v2/summary.json"
             };

for (const [service, url] of Object.entries(urls)) {
    getData(service, url);
}
