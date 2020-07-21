# Who sang this song?

Given a snippet of song lyrics, this model predicts the artist that most likely sings this song.

This model is based on a concept called [bag-of-words](https://en.wikipedia.org/wiki/Bag_of_words_model)

## Input 

From `song3.txt`:

*"Ooh whoa, ooh whoa, ooh whoa  You know you love me, you know you care
Just shout whenever and I'll be there  
You are my love, you are my heart  
And we will never, ever, ever be apart..."*

## Output

Running this program on command line

`./identify_artist.pl test-dataset/song3.txt` 

Generates a prediction, as shown below:

`test-dataset/song3.txt most resembles the work of Justin Bieber (log-probability=-1089.8)`
