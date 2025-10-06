import from byllm.llm { Model }


# === Initialize Gemini Model ===
 glob llm =
    Model(
        model_name="gemini/gemini-2.5-flash",
        # Correct provider prefix
        api_version="v1",
        verbose=True
    );


# === Lecturer Scoring Walker ===
 walker LecturerScore {
    has marks: float;

    # --- Grading logic ---
     def evaluate_student {
        if self.marks < 40 {
            return "Fail";
        } elif self.marks >= 40 and self.marks <= 55  {
            return "Average Student";
        } elif self.marks >= 56 and self.marks <= 75  {
            return "Above Average Student";
        } elif self.marks >= 76 and self.marks <= 100  {
            return "Excellent Student";
        } else {
            return "Invalid — Marks cannot exceed 100.";
        }
    }

    # --- Human-readable explanation ---
     def explain_score {
        feedback = self.evaluate_student();
        return "Student Score: " + str(self.marks) + " marks.\n" + "Performance Category: " + feedback;
    }

    # --- Gemini AI feedback using byLLM ---
     """
    Based on the student's marks and performance level,
    generate personalized academic feedback.

    Example output (~4–6 lines):
    - Strengths or weaknesses
    - Suggested areas of improvement
    - Motivational or professional feedback tone
    Keep language concise and lecturer-like.
    """
    def generate_ai_feedback(marks: float, feedback: str) -> str by llm();
}


# === Main Script ===
 walker Script {
    def main {
        print("=== LECTURER SCORING SHEET ===");
        marks = float(input("Enter student's marks (0–100): "));
        student = LecturerScore(marks=marks);
        print("\n=== SCORE REPORT ===");
        print(student.explain_score());
        category = student.evaluate_student();
        print("\n=== AI FEEDBACK ===");
        print(student.generate_ai_feedback(marks=marks, feedback=category));
    }
}


# === Entry point ===
 with entry {
    app = Script();
    app.main();
}
