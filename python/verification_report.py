import numpy as np


THRESHOLD = 100
SCALE = 1024

REFERENCE = np.array(
    [100, 200, 300, 400],
    dtype=np.int64
)


def inference(sample):

    difference = sample - REFERENCE

    distance = np.sum(
        difference * difference
    )

    score = distance // SCALE

    if score >= THRESHOLD:
        prediction = 1
    else:
        prediction = 0

    return int(distance), int(score), prediction


def load_dataset(filename):

    return np.loadtxt(
        filename,
        delimiter=",",
        skiprows=1,
        dtype=np.int64
    )


def evaluate(filename, expected_class):

    data = load_dataset(filename)

    correct = 0

    for sample in data:

        distance, score, prediction = inference(sample)

        if prediction == expected_class:
            correct += 1

    accuracy = (
        correct / len(data)
    ) * 100

    return len(data), correct, accuracy


if __name__ == "__main__":

    print()
    print("==============================================")
    print(" EDGE-AI ANOMALY DETECTION VERIFICATION")
    print("==============================================")


    normal_total, normal_correct, normal_accuracy = \
        evaluate(
            "normal_samples.csv",
            0
        )


    anomaly_total, anomaly_correct, anomaly_accuracy = \
        evaluate(
            "anomaly_samples.csv",
            1
        )


    total = normal_total + anomaly_total

    correct = (
        normal_correct +
        anomaly_correct
    )

    overall_accuracy = (
        correct / total
    ) * 100


    print()
    print("Reference Features")
    print("----------------------------------------------")
    print(REFERENCE)


    print()
    print("Normal Dataset")
    print("----------------------------------------------")
    print("Samples :", normal_total)
    print("Correct :", normal_correct)
    print(
        "Accuracy: %.2f%%"
        % normal_accuracy
    )


    print()
    print("Anomaly Dataset")
    print("----------------------------------------------")
    print("Samples :", anomaly_total)
    print("Correct :", anomaly_correct)
    print(
        "Accuracy: %.2f%%"
        % anomaly_accuracy
    )


    print()
    print("Overall Verification")
    print("----------------------------------------------")
    print("Total samples :", total)
    print("Correct       :", correct)
    print(
        "Accuracy      : %.2f%%"
        % overall_accuracy
    )


    print()
    print("==============================================")

    if overall_accuracy == 100.0:

        print("VERIFICATION PASSED")

    else:

        print("VERIFICATION COMPLETED")

    print("==============================================")
