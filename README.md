# Automated YouTube Viewing Manager

YouTube has a lot of videos, we all have a lot of YouTube channels we like, but there is still one problem:
The Time.
We don't have the time to fully watch each and every video. But we also want to watch the good ones.
The problem is usually that we don't know which video is good and which one is not worth our time.

The goal of this project is to solve this problem. To see how exactly, check out the `How it works` section.

## How it works

1. It reads the rss feed channel ids from the channelid.json file.
2. It reads the rss feed of each channel
3. for each url:

- It checks if the latest urls have already been processed (if they are on already_processed.json), if it is already on the file, it goes to the next url, else:
- It fetches the transcript with fabric
- It feeds the transcript into ai (any supported by fabric) and validates it, it gets a score from 0 to 100
- depending on the score, here is what happens:
  - score from 100 to 80: Download the video
  - score from 80 to 40: Summarize the video
  - score from 40 to 0: do nothing
- It writes the video url to already_processed.json

## Future improvements

- make custom system prompt for fabric depending on the channel
