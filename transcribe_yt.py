from youtube_transcript_api import YouTubeTranscriptApi

# Function to get the transcript
def get_youtube_transcript(video_id):
    try:
        # Fetch the transcript for the given video ID
        transcript = YouTubeTranscriptApi.get_transcript(video_id)
        
        # Combine the transcript segments into a single text string
        full_transcript = ' '.join([item['text'] for item in transcript])
        
        return full_transcript
    except Exception as e:
        return str(e)

# Example usage
video_url = 'https://www.youtube.com/watch?v=v0sWeLZ8PXg'  # Replace with your video URL
video_id = video_url.split("v=")[-1]

transcript = get_youtube_transcript(video_id)

# Print the transcript or process it further
print(transcript)