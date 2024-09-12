package policy

# Collect all steps from the pipeline
all_steps[step] {
  step := input.pipeline.stages[_].steps[_].step
} else {
  step := input.pipeline.stages[_].steps[_].parallel[_].step
} else {
  step := input.pipeline.stages[_].steps[_].stepGroup.steps[_].step
} else {
  step := input.pipeline.stages[_].steps[_].stepGroup.steps[_].parallel[_].step
}

# Extract the type of each step
step_types[step_type] {
  step := all_steps[_]
  step_type := step.type
}