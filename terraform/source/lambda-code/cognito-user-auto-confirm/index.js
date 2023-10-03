exports.handler = async (event) => {
    console.info('Reached into the lambda' , event)
    // Confirm the user
    event.response.autoConfirmUser = true;
    // Set the email as verified if it is in the request
    if (event.request.userAttributes.hasOwnProperty("email")) {
      event.response.autoVerifyEmail = true;
    }
    
    return event;
  };
  