# ---- non-existent spreadsheet ID
req <- gargle::request_develop(
  endpoint = googlesheets4::sheets_endpoints("sheets.spreadsheets.get")[[1]],
  params = list(
    spreadsheetId = "NOPE_NOT_A_GOOD_ID",
    fields = "spreadsheetId"
  ),
  base_url = "https://sheets.googleapis.com/"
)
req <- gargle::request_build(
  path = req$path,
  method = req$method,
  params = req$params,
  key = gargle_api_key()
)
resp <- request_make(req)

stopifnot(httr::status_code(resp) == 404)
saveRDS(
  redact_response(resp),
  test_path("fixtures", "sheets-spreadsheets-get_404.rds"),
  version = 2
)

resp <- readRDS(test_path("fixtures", "sheets-spreadsheets-get_404.rds"))
response_process(resp)

# ---- non-existent range
req <- gargle::request_develop(
  endpoint = googlesheets4::sheets_endpoints("sheets.spreadsheets.get")[[1]],
  params = list(
    # sheets_example("deaths")
    spreadsheetId = "1ESTf_tH08qzWwFYRC1NVWJjswtLdZn9EGw5e3Z5wMzA",
    ranges = "NOPE!A5:F15",
    fields = "spreadsheetId"
  ),
  base_url = "https://sheets.googleapis.com/"
)
req <- gargle::request_build(
  path = req$path,
  method = req$method,
  params = req$params,
  key = gargle_api_key(),
  base_url = req$base_url
)
resp <- request_make(req)

stopifnot(httr::status_code(resp) == 400)
saveRDS(
  redact_response(resp),
  test_path("fixtures", "sheets-spreadsheets-get_400.rds"),
  version = 2
)

resp <- readRDS(test_path("fixtures", "sheets-spreadsheets-get_400.rds"))
response_process(resp)

# ---- bad field mask
req <- gargle::request_develop(
  endpoint = googlesheets4::sheets_endpoints("sheets.spreadsheets.get")[[1]],
  params = list(
    # sheets_example("deaths")
    spreadsheetId = "1tuYKzSbLukDLe5ymf_ZKdQA8SfOyeMM7rmf6D6NJpxg",
    ranges = "A1:A1",
    fields = "sheets.sheetProperties"
  ),
  base_url = "https://sheets.googleapis.com/"
)
req <- gargle::request_build(
  path = req$path,
  method = req$method,
  params = req$params,
  base_url = req$base_url,
  key = "???" # used the tidyverse API key
)
resp <- gargle::request_make(req)

stopifnot(httr::status_code(resp) == 400)
saveRDS(
  redact_response(resp),
  test_path("fixtures", "sheets-spreadsheets-get-bad-field-mask_400.rds"),
  version = 2
)

resp <- readRDS(test_path("fixtures", "sheets-spreadsheets-get-bad-field-mask_400.rds"))
response_process(resp)
