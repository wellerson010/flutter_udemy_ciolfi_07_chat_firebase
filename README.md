# ChatFirebase

* Firebase
* InputDecoration.collapsed
* Margin
* IconThemeData
* Google SignIn
* NetworkImage
* CircleAvatar

## Todo
* Ajustar logou
* Ajustar appbar com título do usuário
* Ajustar mensagem minha ou não

Configurações firebase:

* build.gradle
* https://console.developers.google.com/
* multiDexEnabled true em app/build.gradle

Multidex:
This error can also occur when you load all google play services apis when you only using afew.
As stated by google:"In versions of Google Play services prior to 6.5, you had to compile the entire package of APIs into your app. In some cases, doing so made it more difficult to keep the number of methods in your app (including framework APIs, library methods, and your own code) under the 65,536 limit.
From version 6.5, you can instead selectively compile Google Play service APIs into your app."
For example when your app needs play-services-maps ,play-services-location .You need to add only the two apis in your build.gradle file at app level as show below:

Comando para pegar o sha-1 firebase:
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

Caminho do JRE:
C:\Program Files\Android\Android Studio\jre\bin