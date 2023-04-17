// const dayjs = require('dayjs');

// exports.handler =  async function(event, context) {
//     var now = dayjs();
//     console.log('+*+++*+*+*+*+START*+*+*+*+*+**+*++*+*');
//     console.log('EVENT OCCURRED!');
//     console.log(`Message created on ${now}`);
//     // Print the event that triggers the lambda
//     console.log("EVENT: \n" + JSON.stringify(event, null, 2));
//     console.log('+*+++*+*+*+*+*END+*+*+*+*+**+*++*+*');
//     return "Hello";
// }

exports.handler = async (event) => {

    const response = {}
    if (event.body !== null && event.body !== undefined) {
        let body = JSON.parse(event.body)
        if (body.name) {
            response = {
                statusCode: 200,
                body: JSON.stringify(`Hello ${body.name}!`),
            };
        }
    }
    else {
        response = {
            statusCode: 200,
            body: JSON.stringify(`Hello, anonymous!`),
        };
    }
    return response;
};