import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import pickle

print("Loading datasets...")

fake = pd.read_csv("archive/Fake.csv")
real = pd.read_csv("archive/True.csv")

fake["label"] = 0
real["label"] = 1

data = pd.concat([fake, real])

print("Preparing text data...")

X = data["text"]
y = data["label"]

vectorizer = TfidfVectorizer(stop_words="english", max_features=5000)

X_vec = vectorizer.fit_transform(X)

print("Training AI model...")

model = LogisticRegression(max_iter=1000)

model.fit(X_vec, y)

pickle.dump(model, open("model.pkl","wb"))
pickle.dump(vectorizer, open("vectorizer.pkl","wb"))

print("Training completed!")