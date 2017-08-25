# FaceBook-Feeds

## What it does
1. Feeds from different pages from facebook
2. Mark feeds as favorite to display them in another tab

## UI
1. Used only Programming, ie no storyboard is used
2. UIColletionView, UIScrollView used as main building blocks

## Backend
1. Feeds from facebook were gathered using the Graph API.
2. Simple HTTP Requests were made.
3. Testing can be done using the link https://developers.facebook.com/tools/explorer/

## How to Use
1. Register yourself as developer on facebook
2. Go to Setting and get you App Access Token using the App ID and Secret Token
3. Set the value of `your_token` with this access token
4. Take the url of facebook pages and add them to `pagesURLs`. Both the variables are located in ApiService.swift

#### Bugs and features to be added
1. Works only with one orientation
2. Problems with UICollectionView UIEdgeInsets.
3. Have to refresh the page for Favorites page to act properly
4. Only limited number of feeds requested. Load more options to be added
5. Setting Control to be added
