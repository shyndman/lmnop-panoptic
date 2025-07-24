from pathlib import Path

from deepface import DeepFace
from term_image.image import from_file


def main() -> None:
  # for image_path in Path("images/verification").glob("*"):
  #   print(f"\n# {image_path}")
  #   print(from_file(image_path))
  #   dfs = DeepFace.find(img_path=str(image_path), db_path="images/db")
  #   print("Recognition:")
  #   print(dfs)
  #   print("Analysis:")
  #   objs = DeepFace.analyze(img_path=str(image_path), actions=["age", "gender", "race", "emotion"])
  #   print(objs)
  #   print("")

  DeepFace.stream(
    db_path="images/db", output_path="/tmp/recognition.mp4", enable_face_analysis=False
  )
