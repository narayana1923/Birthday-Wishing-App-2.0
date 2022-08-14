# Birthday Wishing App

- This App is an follow-up of <a href="https://github.com/narayana1923/Birthday-Wishing-App" target="_blank">this app</a> using flutter

## Added Features compared to previous version:
    > Added support to change username and password.
    > Added background music support and can be changed if needed.
    > Added download and share options, user can download/share individual content or entire content at once.
    > Instagram like popup preview feature for videos and images.

## Optimizations from previous version
    > Only fetches data to stream/display when not downloaded
    > Shares from local files if already downloaded
    > Generates thumbnails locally if content is already downloaded

# **Note**

    > If you wish to make any changes or use the app connect it to you Firebase console and make necessary changes in the google-services.json (dir:android\app\google-services.json )
    
    > Instead of fetching data from realtime database everytime, I have changed to store the realtime database snapshot locally (Dir: assets\files\birthdayfafa-export.json), so make changes accordingly

# Real Time DataBase Snippets

- Database is majorly divided into the below four categories
  ![Dataset](https://github.com/narayana1923/images/blob/master/realtime%20DB.png?raw=true)

- Description is optional and can be removed if needed
  ![Images Dataset](https://github.com/narayana1923/images/blob/master/images.png?raw=true)

- In memes dataset, title is used for sorting the data
  ![Memes Dataset](https://github.com/narayana1923/images/blob/master/memes.png?raw=true)
  
- Number is required to reply back in whatsapp
  ![Videos Dataset](https://github.com/narayana1923/images/blob/master/videos.png?raw=true)

# Future work

- Optimization of resource fetching
- Uploading content to database
- Optimizing thumbnail generation for videos
- Caching image previews better

# Requirements

- Android **6.0+**
- minsdk version **23**



# Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# About Author

        - Lakshmi Narayana Velayudam
        - Pursuing B.Tech 4th year (2023 passout)
        - Tirupati, India
        - Skills: C, C++, Java, Python, SQL, DSA        

# Contact

- <a href="https://www.linkedin.com/in/lakshmi-narayana-velayudam/">LinkedIn</a>
- <a href="mailto: lcchinnu@gmail.com">Mail</a>


