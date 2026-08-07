from pathlib import Path
import re

manifest = Path('android/app/src/main/AndroidManifest.xml')
if not manifest.exists():
    raise SystemExit('AndroidManifest.xml introuvable. Lance flutter create avant ce script.')

text = manifest.read_text(encoding='utf-8')
permissions = [
    '    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />',
    '    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />',
]
manifest_tag = re.search(r'<manifest\b[^>]*>', text)
if manifest_tag is None:
    raise SystemExit('Balise <manifest> introuvable.')
insert_at = manifest_tag.end()
missing_permissions = [p for p in permissions if p not in text]
if missing_permissions:
    text = text[:insert_at] + '\n' + '\n'.join(missing_permissions) + text[insert_at:]

text = re.sub(
    r'android:label="[^"]*"',
    'android:label="Moi, Géomaticien"',
    text,
    count=1,
)
text = re.sub(
    r'android:icon="[^"]*"',
    'android:icon="@mipmap/ic_launcher"',
    text,
    count=1,
)
if 'android:roundIcon=' in text:
    text = re.sub(
        r'android:roundIcon="[^"]*"',
        'android:roundIcon="@mipmap/ic_launcher"',
        text,
        count=1,
    )
else:
    text = text.replace(
        '<application',
        '<application\n        android:roundIcon="@mipmap/ic_launcher"',
        1,
    )
manifest.write_text(text, encoding='utf-8')

for candidate in [
    Path('android/app/build.gradle.kts'),
    Path('android/app/build.gradle'),
]:
    if not candidate.exists():
        continue
    gradle = candidate.read_text(encoding='utf-8')
    gradle = re.sub(
        r'minSdk\s*=\s*flutter\.minSdkVersion',
        'minSdk = 24',
        gradle,
    )
    gradle = re.sub(
        r'minSdkVersion\s+flutter\.minSdkVersion',
        'minSdkVersion 24',
        gradle,
    )
    candidate.write_text(gradle, encoding='utf-8')
    break

print('Android configuré : nom, permissions GPS, minSdk 24 et icône launcher.')
