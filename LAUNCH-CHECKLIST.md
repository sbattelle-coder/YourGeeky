# Going public checklist

Do these together, on the day the preview password comes off yourgeeky.com.

1. **Take the password screen out** of `docs/index.html` (the `#gate` block and the two
   "Preview password" scripts) and remove the `noindex` line so search engines can list the site.
2. **Make it open source.** Add a `LICENSE` file (MIT is the simple, common choice) to the repo.
3. **Update the website wording** now that it's true: say YourGeeky is "open source" in the
   "Is this safe?" and "Free, and open for anyone to check" sections.
4. **Fill in the suggestions form key** (`YOUR_WEB3FORMS_ACCESS_KEY` in `docs/index.html`)
   if that isn't done yet.
5. **Test the install line** on a Mac: `curl -fsSL https://yourgeeky.com/install.sh | bash`.
