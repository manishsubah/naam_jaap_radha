# Security and privacy

What JaapMala stores, where it goes, and what must never be committed.

## What stays out of git

| File | What it holds | How it's protected |
| --- | --- | --- |
| `config/google_oauth.json` | Google OAuth client IDs | Gitignored; copy from `config/google_oauth.example.json` |
| `ios/Flutter/GoogleOAuth.local.xcconfig` | iOS sign-in URL scheme | Gitignored |
| `android/key.properties` | Release keystore path and passwords | Gitignored; copy from `android/key.properties.example` |
| `*.jks`, `*.keystore`, `*.p12`, `*.p8`, `*.pem`, `*.key` | Signing keys | Gitignored |
| `google-services.json`, `GoogleService-Info.plist`, `.env*` | Firebase or other service config | Gitignored |

OAuth client IDs aren't secret: they ship inside every app binary and only
work for this app's bundle ID, package name and signing key. They're kept out
of git anyway so each developer and CI machine uses its own config.

CI runs [gitleaks](https://github.com/gitleaks/gitleaks) on every push and
pull request and fails the build if a key, token or password is committed.

**If a secret is ever committed:** rotate it first (create a new key or client
and delete the old one), then remove it from git history. Deleting the file in
a new commit isn't enough; it stays in history.

## What the app stores on the device

| Data | Where | Notes |
| --- | --- | --- |
| Jaap records, naams, settings | Hive database in the app's private folder | Not encrypted by the app |
| Thoughts journal text | Same Hive database | Not encrypted by the app |
| Voice notes | `.m4a` files in the app's private folder | Not encrypted by the app |
| Google sign-in tokens | iOS Keychain / Google Play services | Managed by Google's sign-in library; the app never writes tokens to disk |

The app's folder is sandboxed: other apps can't read it. Both iOS and Android
encrypt it on disk once the phone has a passcode. Anyone holding an unlocked
phone can open the app, as with most journaling apps. App-level encryption
(for example an encrypted Hive box with its key in the Keychain) would add
protection against forensic access to an unlocked or jailbroken phone, at the
cost of a data migration; it isn't done today.

The app writes no logs and makes no plain-HTTP requests.

## What leaves the device

| Data | Sent to | When |
| --- | --- | --- |
| Jaap records and custom naams | The user's own Google Drive app data folder | Only after the user signs in with Google |
| Speech for voice-to-text | Apple or Google speech recognition | Only while the user dictates a thought |

- Google backup asks for one permission, `drive.appdata`. It lets the app
  read and write its own hidden folder and nothing else in the user's Drive.
- Thoughts and voice notes are **not** uploaded to Google backup.
- There's no JaapMala server: no developer can see any user's data.
- Users can delete the backup at **drive.google.com → Settings → Manage apps →
  JaapMala → Delete hidden app data**.
- Android's own device backup (if the user has it on) also includes the app's
  folder, in the user's encrypted Google backup.

## Before a store release

1. **Create an Android upload key** (once, and back it up: losing it blocks updates):

   ```bash
   keytool -genkey -v -keystore ~/keys/jaapmala-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

   Then create `android/key.properties` from the example file. Without it,
   release builds fall back to the debug key, which Google Play rejects.
2. **Register the Play signing key with Google sign-in:** add an Android OAuth
   client with the SHA-1 from Play Console → **Protected with Play → Play Store
   protection → Manage Play app signing**.
3. **Build with obfuscated Dart code** and keep the symbol files private (out of git):

   ```bash
   flutter build appbundle --obfuscate --split-debug-info=build/symbols --dart-define-from-file=config/google_oauth.json
   ```

4. **Publish the OAuth consent screen** (Google Auth Platform → Audience) so
   accounts outside the test-user list can sign in.
5. **Fill in the privacy forms:** App Store privacy details and Google Play's
   Data safety form. Declare that the app collects no data on a developer
   server; backup goes to the user's own Google account; and audio is used for
   speech-to-text.
