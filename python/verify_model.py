
THRESHOLD = 100
SCALE = 1024

REFERENCE = np.array(
    [100, 200, 300, 400],
    dtype=np.int64
)


def calculate_score(sample):
    difference = sample - REFERENCE

    distance = np.sum(
        difference * difference
    )

    score = distance // SCALE

    return int(score)


def classify(score):
    if score >= THRESHOLD:
        return 1

    return 0


def verify_dataset(filename, expected_class):

    data = np.loadtxt(
        filename,
        delimiter=",",
        skiprows=1,
        dtype=np.int64
    )

    correct = 0

    total = len(data)

    for sample in data:

        score = calculate_score(sample)

        prediction = classify(score)

        if prediction == expected_class:
            correct += 1

    accuracy = (correct / total) * 100

    return total, correct, accuracy


if __name__ == "__main__":

    print("======================================")
    print("AI ANOMALY DETECTION VERIFICATION")
    print("======================================")

    normal_total, normal_correct, normal_accuracy = \
        verify_dataset(
            "normal_samples.csv",
            0
        )

    anomaly_total, anomaly_correct, anomaly_accuracy = \
        verify_dataset(
            "anomaly_samples.csv",
            1
        )


    total_cases = normal_total + anomaly_total

    total_correct = (
        normal_correct +
        anomaly_correct
    )

    overall_accuracy = (
        total_correct /
        total_cases
    ) * 100


    print()
    print("NORMAL DATA")
    print("--------------------------------------")
    print("Samples :", normal_total)
    print("Correct :", normal_correct)
    print("Accuracy:", f"{normal_accuracy:.2f}%")

    print()
    print("ANOMALY DATA")
    print("--------------------------------------")
    print("Samples :", anomaly_total)
    print("Correct :", anomaly_correct)
    print("Accuracy:", f"{anomaly_accuracy:.2f}%")

    print()
    print("OVERALL")
    print("--------------------------------------")
    print("Total samples :", total_cases)
    print("Correct       :", total_correct)
    print("Accuracy      :", f"{overall_accuracy:.2f}%")

    print()
    print("======================================")
    print("VERIFICATION COMPLETE")
    print("======================================")
"]
