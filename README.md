# Take home task for iOS develloper role

Firstly, thanks for applying to work with us at BrightHR. We ask all potential
candidates to complete a task to help assess your technical skills.

We appreciate your time is precious so don't spend too long on it — however it is
important to let us know what you have left out in your README so we can understand
what you _would_ do given more time.

You are free to decide what aspects of the solution you want to show off/focus on, but
here are a few guidelines as to what we will be looking for:

- Swift/SwiftUI usage
- Modern iOS architecture best practice (state management, dependency injection,
  separation of concerns)
- Demonstration of unit/UI testing
- Consideration for future requirements

With regards to visual design we expect to see enough to demonstrate your command of
SwiftUI and Human Interface Guidelines, but don't consider it a priority.

We're as interested in the process that you go through to develop the code as the end
result, so please commit early and often so we can see the steps that you go through to
arrive at your solution. We want to see a git repository containing your solution,
ideally uploaded to your own GitHub account.

## The task

Use the endpoints provided below to create a simple iOS app with a screen displaying
absences.

For each absence show:

- start date
- end date
- employee name
- approved/pending approval
- absence type

Please add at least **two** of the following features:

1. Include a visual indication that an absence has conflicts, using the conflict
   endpoint.
1. Allow the list to be sorted by dates, absence type, and name.
1. When an employee's name is tapped, show all of their absences.

Your solution README should include:

- Clear instructions on how to run the application and its tests.
- A brief outline of how you would approach any functionality that is left incomplete.

## The endpoints

`https://front-end-kata.brighthr.workers.dev/api/absences` will return a full list of
all absences.

`https://front-end-kata.brighthr.workers.dev/api/conflict/{id}` for a given absence id
will indicate if there are conflicts or not.

## Build tools

| Tool       |    Version |
| :--------- | ---------: |
| iOS Target |       16.0 |
| Swift      | 5.0 or 6.0 |

You're free to choose the architecture (MVVM, TCA, or otherwise) and dependencies that
best show off your skills — be prepared to justify your choices.

## Submission

1. Fork the repository.
2. Implement the task with meaningful, incremental commits that demonstrate your
   approach.
3. Once complete, push your implementation to your GitHub repository.
4. Submit the GitHub repository URL to the provided submission link/email.

## Next steps

When you've finished please make your solution repo available on GitHub and share the
link back with us.

We will take a look as soon as we can and if you are successful at this stage your task
solution will form the basis of the technical part of the interview stage.

- We'll begin by getting you to talk through your solution. There is no expected
  structure to this, we're interested in how you think about code and how you
  communicate what you've done.
- We may ask you to explain how you would approach a new requirement or solve a
  specific problem in your solution. This will not be a live coding exercise, but we
  will expect you to be able to comprehensively describe what steps you would take in
  the context of your current solution.
