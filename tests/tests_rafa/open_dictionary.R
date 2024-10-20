
download_and_open_excel <- function(url) {
  # Extract the file name from the URL
  destfile <- basename(url)

  # Download the file
  download.file(url, destfile, mode = "wb")  # Use mode = "wb" for binary files like Excel

  # Open the file based on the operating system
  if (.Platform$OS.type == "windows") {
    # For Windows
    shell.exec(destfile)
  } else if (Sys.info()["sysname"] == "Darwin") {
    # For macOS
    system(paste("open", shQuote(destfile)))
  } else {
    # For Unix/Linux
    system(paste("xdg-open", shQuote(destfile)))
  }
}
