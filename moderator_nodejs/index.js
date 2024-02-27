const express = require('express');
const app = express();
const axios = require('axios');

const bodyParser = require('body-parser');

const port = 3000;

let api_responses_cache = [];

//Views Init
app.set('view engine', 'ejs');
app.set('views', "./src/views");


// Serve static files
app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});
app.post('/predict', async (req, res) => {

  console.log(req.body);

  const dataholder = req.body;

  const isEmpty = Object.values(dataholder).every(paragraph => paragraph.trim() === '');
  console.log(isEmpty)
  const isOneOrTwoEmpty = Object.values(dataholder).filter(paragraph => paragraph.trim() === '').length >= 1 &&
    Object.values(dataholder).filter(paragraph => paragraph.trim() === '').length <= 2;
    console.log(isOneOrTwoEmpty)


  const apiUrl = 'https://moderation.logora.fr/predict';
  api_responses_cache = []; //clearing cache


  try {
    if (isEmpty || isOneOrTwoEmpty) {
      const errorMessage = encodeURIComponent("Some Data are empty please send a completed form. Cannot send to API.");
      return res.redirect('/?message=' + errorMessage);
    }
    if (Array.isArray(dataholder)) {
      for (const element of dataholder) {
        const queryParams = new URLSearchParams({
          text: `${element}`,
          language: 'fr-FR'
        });
        const urlWithParams = `${apiUrl}?${queryParams}`;
        const response = await axios.get(urlWithParams);
        api_responses_cache.push({ [element]: response.data });
        console.log('API Response for', element, ':', response.data);
      }
    } else if (typeof dataholder === 'object') {
      for (const key in dataholder) {
        const queryParams = new URLSearchParams({
          text: `${dataholder[key]}`,
          language: 'fr-FR'
        });
        const urlWithParams = `${apiUrl}?${queryParams}`;
        const response = await axios.get(urlWithParams);
        api_responses_cache.push({ [dataholder[key]]: response.data });
        console.log('API Response for', key, ':', response.data);
      }
    } else {
      throw new Error('Invalid data format in request body');
    }



    res.redirect('/result_predict');

  } catch (error) {
    // Handle errors
    console.error('Error making API request:', error.message);
    return res.status(500).send('Error making API request');
  }


});

app.post('/score', async (req, res) => {
  console.log(req.body)

  const dataholder = req.body;

  const isEmpty = Object.values(dataholder).every(paragraph => paragraph.trim() === '');
  const isOneOrTwoEmpty = Object.values(dataholder).filter(paragraph => paragraph.trim() === '').length >= 1 &&
    Object.values(dataholder).filter(paragraph => paragraph.trim() === '').length <= 2;


  const apiUrl = 'https://moderation.logora.fr/score';
  api_responses_cache = []; //clearing cache
  try {
    if (isEmpty || isOneOrTwoEmpty) {
      const errorMessage = encodeURIComponent("Some Data are empty please send a completed form. Cannot send to API.");
      return res.redirect('/?message=' + errorMessage);
    }

    if (Array.isArray(dataholder)) {
      for (const element of dataholder) {
        const queryParams = new URLSearchParams({
          text: `${element}`,
          language: 'fr-FR'
        });
        const urlWithParams = `${apiUrl}?${queryParams}`;
        const response = await axios.get(urlWithParams);
        api_responses_cache.push({ [element]: response.data });
        console.log('API Response for in array', element, ':', response.data);
      }
    } else if (typeof dataholder === 'object') {
      for (const key in dataholder) {
        const queryParams = new URLSearchParams({
          text: `${dataholder[key]}`,
          language: 'fr-FR'
        });
        const urlWithParams = `${apiUrl}?${queryParams}`;
        const response = await axios.get(urlWithParams);
        api_responses_cache.push({ [dataholder[key]]: response.data });
        console.log('API Response for', key, ':', response.data);
      }
    } else {
      throw new Error('Invalid data format in request body');
    }



    res.redirect('/result_score');

  } catch (error) {
    console.error('Error making API request:', error.message);
    return res.status(500).send('Error making API request');
  }



});

app.get('/result_predict', (req, res) => {

  console.log(api_responses_cache)

  try {
    const responses = [];
    if (Object.entries(api_responses_cache).length === 0) {
      throw new Error("api_responses_cache is empty");
    }
    api_responses_cache.forEach(response => {
      for (const key in response) {
        const nestedObject = response[key];

        const prediction = nestedObject.prediction;
        responses.push({ [key]: prediction[0] });

      }
    });
    console.log(responses);
    res.render('result_predict', { api_responses: responses });
  } catch (error) {
    res.send("Error while retrieving data...Redirecting");

    setTimeout(() => {
      res.redirect('/');
    }, 2000);
  }


});

app.get('/result_score', (req, res) => {

  console.log(api_responses_cache)
  const responses = [];
  if (Object.entries(api_responses_cache).length === 0) {
    throw new Error("api_responses_cache is empty");
  }
  try {
    api_responses_cache.forEach(response => {
      for (const key in response) {
        const nestedObject = response[key];

        const score = nestedObject.score;
        responses.push({ [key]: score });

      }
    });
    console.log(responses);
    res.render('result_score', { api_responses: responses });
  }
  catch (error) {
    res.send("Error while retrieving data...Redirecting");

    setTimeout(() => {
      res.redirect('/');
    }, 2000);
  }


});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});