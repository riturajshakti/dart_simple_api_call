# Changelog

All notable changes to this project will be documented in this file.

## [v1.0.0] - 2025-02-16

### Added
- Initial release of the library.
- Core functionality of API call is implemented including the following:
  - Basic api call with these methods: 
    - `GET`
    - `POST`
    - `PUT`
    - `PATCH`
    - `DELETE`
    - `HEAD`
    - `OPTIONS`
  - Setting up these data in API Request
    - Request Headers
    - Request Body
    - JSON Data in request Body
    - Form Data in request Body
    - Form URL Encoded Data in request Body
    - URL Search Params in request URL
    - Timeout in api abort
    - `onSendProgress()` handler for form data upload progress updates
    - `onReceiveProgress()` handler for download progress updates
  - Accessing these data from API Response:
    - `Ok`, A bool value to check if response is successful
    - Response Headers
    - Response Body
    - Response Body in JSON available if response is json
    - Status Code
    - Status Message
    - Streams for SSE
    - Error message if error occurs
- Basic examples and information is provided in the `README.md`.