# my_app

A new Flutter project

## Upload the ios app to testflight

### 1. Manually (need to repeat the steps each time)

```bash
flutter build ipa --release --build-name=1.0.1 --build-number=42 -t lib/main.dart

xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey <your_api_key> --apiIssuer <your_issuer_id>
```

### 2. Using the script

#### 2.1 One time set-up

1. Create a file called versions in the root of your project.
Inside this file, set `ios_version_name` and `ios_build_number`
2. Create an api key to be used to upload the app to testflight. You can create it at <https://appstoreconnect.apple.com/access/integrations/api>.
3. Get your issuer id, you can find it at <https://appstoreconnect.apple.com/access/integrations/api>.
4. Create the script and related files at the path `<your-project-root>/scripts/upload_to_testflight/` with the following content:

    - The script file itself: `upload_to_testflight.sh`
    - The api key name file: `api_key_name`
    - The issuer id file: `issuer_id`

5. **IMPORTANT:** Add the issuer id and api key files to the `.gitignore` file

#### 2.2 Run the script

1. Update the ios version name and build number in the versions file

2. Run the script from the terminal

```bash
sh -e <path-to-script>/upload_to_testflight.sh --project-root <path-to-project-root>
```
