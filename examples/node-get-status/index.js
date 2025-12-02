const axios = require('axios');
const colors = require('colors');

async function getData() {
  const url = "https://www.githubstatus.com/api/v2/summary.json";
  try {
    const response = await axios.get(url);
    const result = response.data;
    const status  =  result.status;
    switch (status.indicator) {
       case "critical":
            console.log(colors.red(status.description));
            break;
       case "major":
            console.log(colors.orange(status.description));
            break;
       case "minor":
            console.log(colors.yellow(status.description));
            break;
        default:
            console.log(colors.green(status.description));
    }
  } catch (error) {
    console.error(error.message);
  }
}

getData();
