import allClasses from "./allClasses.json" assert { type: "json" };
import modifiedClasses from "./modifiedClassModels.json" assert { type: "json" };

// let subjectEquals = (sub1, sub2) => {
//     if (sub1.name === sub2.name && sub1.coef === sub2.coef)
// }

for (let modifiedClass of modifiedClasses) {
  console.log(`--- Analysing ${modifiedClass.name} --- `);
  let presetClass = allClasses.find(
    (preset) => preset.name == modifiedClass.name
  );

  if (presetClass === undefined) {
    console.log(`This is a new class`);
    continue;
  }

  if (presetClass.hasExams !== modifiedClass.hasExams) {
    console.log(`this class changed hasExams to ${modifiedClass.hasExams}`);
  }

  let uneditedSubjects = [];
  let editedSubjects = [];
  let deletedSubjects = [];
  /// created or renamed
  let createdSubjects = [];

  for (let newSub of modifiedClass.subjects) {
    let presetSub = presetClass.subjects.find((s) => s.name === newSub.name);

    if (presetSub === undefined) {
      createdSubjects.push(newSub);
      continue;
    }

    if (newSub.coef == presetSub.coef) {
      if (newSub.subSubjects == presetSub.subSubjects) {
        uneditedSubjects.push(newSub);
        continue;
      }
    }

    editedSubjects.push(newSub);
  }

  deletedSubjects = presetClass.subjects.filter(
    (s) =>
      editedSubjects.find((s2) => s2.name === s.name) === undefined &&
      createdSubjects.find((s2) => s2.name === s.name) === undefined &&
      uneditedSubjects.find((s2) => s2.name === s.name) === undefined
  );

  console.log(`editedSubs:`);
  console.log(editedSubjects);
  console.log(`createdSubjects:`);
  console.log(createdSubjects);
  console.log(`deletedSubjects:`);
  console.log(deletedSubjects);

  //   console.log(presetClass);
  //   console.log(modifiedClass);
}
