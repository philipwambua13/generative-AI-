"""Lecturer Scoring Sheet"""

import from byllm.llm { Model }


glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);


"""Provide feedback based on marks"""
def evaluate_score(marks: int) -> str by llm();


walker ScoreSheet {
    has marks: int;

    can start with root entry;
    can assess with turn entry;
}


node turn {
    has result: str;
}


impl ScoreSheet.start{
    if not [root-->( ` ? turn ) ] {
        if self.marks < 40 {
            next = root ++> turn("Fail");
        } elif self.marks >= 40 and self.marks <= 55  {
            next = root ++> turn("Average Student");
        } elif self.marks >= 56 and self.marks <= 75  {
            next = root ++> turn("Above Average Student");
        } elif self.marks >= 76 and self.marks <= 100  {
            next = root ++> turn("Excellent Student");
        } else {
            next = root ++> turn("Invalid");
        }
    } else {
        next = [root-->( ` ? turn ) ];
    }
    visit next;
}


impl ScoreSheet.assess{
    if [-->] {
        visit [-->];
    } else {
        print("Marks: " + str(self.marks));
        print("Result: " + here.result);
        disengage;
    }
}
