from pathlib import Path
import re


def insert_manifest_requirements() -> None:
    manifest = Path("android/app/src/main/AndroidManifest.xml")
    if not manifest.exists():
        raise SystemExit(
            "AndroidManifest.xml introuvable. Lance flutter create avant ce script."
        )

    text = manifest.read_text(encoding="utf-8")
    declarations = [
        (
            "android.permission.ACCESS_FINE_LOCATION",
            '    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />',
        ),
        (
            "android.permission.ACCESS_COARSE_LOCATION",
            '    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />',
        ),
        (
            "android.permission.READ_EXTERNAL_STORAGE",
            '    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="28" />',
        ),
        (
            "android.hardware.location.gps",
            '    <uses-feature android:name="android.hardware.location.gps" android:required="false" />',
        ),
    ]
    manifest_tag = re.search(r"<manifest\b[^>]*>", text)
    if manifest_tag is None:
        raise SystemExit("Balise <manifest> introuvable.")

    missing = [line for marker, line in declarations if marker not in text]
    if missing:
        position = manifest_tag.end()
        text = text[:position] + "\n" + "\n".join(missing) + text[position:]

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
    if "android:roundIcon=" in text:
        text = re.sub(
            r'android:roundIcon="[^"]*"',
            'android:roundIcon="@mipmap/ic_launcher"',
            text,
            count=1,
        )
    else:
        text = text.replace(
            "<application",
            '<application\n        android:roundIcon="@mipmap/ic_launcher"',
            1,
        )
    manifest.write_text(text, encoding="utf-8")


def configure_kotlin_gradle(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    text = re.sub(
        r"minSdk\s*=\s*flutter\.minSdkVersion",
        "minSdk = 24",
        text,
    )

    if "val keystoreProperties = Properties()" not in text:
        imports = "import java.io.FileInputStream\nimport java.util.Properties\n\n"
        if "import java.util.Properties" not in text:
            text = imports + text
        prelude = """
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

"""
        text = text.replace("android {", prelude + "android {", 1)

    if 'create("release")' not in text:
        signing = """    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

"""
        text = text.replace("    buildTypes {", signing + "    buildTypes {", 1)

    text = text.replace(
        'signingConfig = signingConfigs.getByName("debug")',
        "signingConfig = if (keystorePropertiesFile.exists()) "
        'signingConfigs.getByName("release") else signingConfigs.getByName("debug")',
    )
    path.write_text(text, encoding="utf-8")


def configure_groovy_gradle(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    text = re.sub(
        r"minSdkVersion\s+flutter\.minSdkVersion",
        "minSdkVersion 24",
        text,
    )
    text = re.sub(
        r"minSdkVersion\s*=\s*flutter\.minSdkVersion",
        "minSdkVersion 24",
        text,
    )

    if "def keystoreProperties = new Properties()" not in text:
        prelude = """
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

"""
        text = text.replace("android {", prelude + "android {", 1)

    if "signingConfigs {" not in text:
        signing = """    signingConfigs {
        release {
            if (keystorePropertiesFile.exists()) {
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
                storeFile file(keystoreProperties['storeFile'])
                storePassword keystoreProperties['storePassword']
            }
        }
    }

"""
        text = text.replace("    buildTypes {", signing + "    buildTypes {", 1)

    text = re.sub(
        r"signingConfig\s+signingConfigs\.debug",
        "signingConfig keystorePropertiesFile.exists() "
        "? signingConfigs.release : signingConfigs.debug",
        text,
    )
    path.write_text(text, encoding="utf-8")


def configure_gradle() -> None:
    kotlin = Path("android/app/build.gradle.kts")
    groovy = Path("android/app/build.gradle")
    if kotlin.exists():
        configure_kotlin_gradle(kotlin)
        return
    if groovy.exists():
        configure_groovy_gradle(groovy)
        return
    raise SystemExit("Fichier Gradle Android introuvable.")


insert_manifest_requirements()
configure_gradle()
print(
    "Android configuré : GPS, accès CSV via sélecteur système, minSdk 24, "
    "icône et signature release."
)
