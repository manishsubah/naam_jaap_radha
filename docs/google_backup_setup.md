# Google backup setup

JaapMala can save each user's jaap records to **their own Google account**. The
records go in the Google Drive *app data folder*: a hidden space that only
JaapMala can read or write. It doesn't show up in the user's Drive files or
count against anything they see.

Google requires every app that uses sign-in to register its own OAuth clients.
Until you do the steps below, the app works normally and the Settings screen
says Google backup isn't set up.

You do this once per app (not per user). It takes about 15 minutes.

## 1. Create a Google Cloud project

1. Open <https://console.cloud.google.com/> and sign in with the Google account
   that will own the app.
2. Create a project, for example `JaapMala`.

## 2. Turn on the Google Drive API

**APIs & Services → Library**, search for **Google Drive API**, and click
**Enable**.

## 3. Set up the consent screen

Open **Google Auth Platform** (or **APIs & Services → OAuth consent screen**).

1. **Branding**: app name `JaapMala`, your support email, and your developer
   contact email.
2. **Audience**: choose **External**. While the app is in **Testing**, add
   the Gmail addresses that may sign in (up to 100) under **Test users**.
3. **Data access**: add the scope
   `https://www.googleapis.com/auth/drive.appdata`. This is the only
   permission JaapMala asks for. It can't see any of the user's own files.

Before you release to everyone, publish the app on this screen. Google may ask
you to verify the app first.

## 4. Create three OAuth client IDs

Go to **Clients** (or **APIs & Services → Credentials**) and choose
**Create client** three times.

| Type | Field | Value |
| --- | --- | --- |
| iOS | Bundle ID | `com.naam.jaap.manishsubah.naamJaap` |
| Android | Package name | `com.naam.jaap.manishsubah.naam_jaap` |
| Android | SHA-1 | See below |
| Web application | Name | `JaapMala server` (no redirect URIs needed) |

To get the Android **SHA-1** for debug builds:

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

For release builds, add another Android client with the SHA-1 of your release
key. If you publish on Google Play, use the **App signing key** SHA-1 from
Play Console → **Setup → App signing**.

> If you change the bundle ID or package name later, create new clients for
> the new IDs.

## 5. Add the IDs to the project

These files are gitignored, so each developer or CI machine keeps its own copy.

**`config/google_oauth.json`**: copy `config/google_oauth.example.json` and fill in:

- `GOOGLE_IOS_CLIENT_ID`: the iOS client ID.
- `GOOGLE_SERVER_CLIENT_ID`: the **Web application** client ID. Android
  needs this one, not the Android client ID.

**`ios/Flutter/GoogleOAuth.local.xcconfig`**: the iOS client's
**iOS URL scheme**, which is the client ID reversed:

```
GOOGLE_REVERSED_CLIENT_ID = com.googleusercontent.apps.1234567890-iosclientid
```

## 6. Run the app with the IDs

```bash
flutter run --dart-define-from-file=config/google_oauth.json
```

Use the same flag for release builds, for example
`flutter build ipa --dart-define-from-file=config/google_oauth.json`.

Then open **Settings → Google backup → Sign in with Google**.

## How sync works

- Records are always saved on the device first, so the app works offline.
- After sign-in, JaapMala syncs at launch, when the app comes back to the
  foreground, 5 seconds after any change, and when you tap **Sync now**.
- Each record (one day + one naam) carries the time it was last changed. When
  two devices disagree, the most recent change wins. Deletions sync too.
- Signing out keeps the records on the device. Signing in again merges them back.
- Users can remove JaapMala's data from Google Drive at
  **drive.google.com → Settings → Manage apps → JaapMala → Delete hidden app data**.

## Troubleshooting

| Problem | Fix |
| --- | --- |
| Settings says backup isn't set up | Run with `--dart-define-from-file=config/google_oauth.json`. |
| iOS crashes or errors on sign-in about URL schemes | Check `GOOGLE_REVERSED_CLIENT_ID` in `GoogleOAuth.local.xcconfig`, then do a clean build. |
| Android sign-in fails right away | The SHA-1 or package name doesn't match an Android client, or `GOOGLE_SERVER_CLIENT_ID` isn't the **Web** client ID. |
| "Access blocked: app not verified" | Add the account as a test user, or publish the consent screen. |
| Status shows "Sync paused" | Tap **Reconnect** in Settings; Google needs the user to approve access again. |
