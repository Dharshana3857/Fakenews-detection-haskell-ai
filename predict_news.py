import pickle
import sys

model = pickle.load(open("model.pkl","rb"))
vectorizer = pickle.load(open("vectorizer.pkl","rb"))

file = sys.argv[1]

text = open(file, encoding="utf8").read()

vec = vectorizer.transform([text])

prediction = model.predict(vec)
probability = model.predict_proba(vec)

fake_prob = probability[0][0] * 100
real_prob = probability[0][1] * 100

print("-----------------------------------")
print("FAKE NEWS ANALYSIS REPORT")
print("-----------------------------------")

if prediction[0] == 0:
    print("Prediction : FAKE NEWS")
    print("Confidence :", round(fake_prob,2), "%")
else:
    print("Prediction : REAL NEWS")
    print("Confidence :", round(real_prob,2), "%")

print("-----------------------------------")