const bytesToMB = bytes => {
  return bytes / 1000000;
};

function generateSixDigitRandomNumber() {
  return Math.floor(Math.random() * 900000) + 100000;
}

module.exports = { bytesToMB, generateSixDigitRandomNumber };
