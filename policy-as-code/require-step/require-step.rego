package pipeline

# Deny pipelines that are missing required steps
# NOTE: Try adding "ShellScript" to the 'required_steps' list to see the policy fail
deny[msg] {
	# Find all stages ...
	stage = input.pipeline.stages[_].stage

	# ... that are deployments
	stage.type == "CI"

	# ... and create a list of all step types in use
	existing_steps := [s | s = stage.spec.execution.steps[_].step.type]

	# Pull all the steps that are in parallel
	parallel_steps := [p | p = stage.spec.execution.steps[_].parallel[_].step.type]

	steps := array.concat(existing_steps,parallel_steps)

	# Pull all steps that could be in Step Groups
	step_groups := [x | x = stage.spec.execution.steps[_].stepGroup[_].steps[_].step.type]
	parallel_in_step_groups := [g | g = stage.spec.execution.steps[_].stepGroup[_].steps[_].parallel[_].step.type]

	# pipeline.stages.stage.spec.execution.steps.stepGroup.steps.parallel.step

	groups := array.concat(step_groups,parallel_in_step_groups)

	# Combine the two lists to get all step types in use
	all_steps := array.concat(steps,groups)

	# For each required step ...
	required_step := required_steps[_]

	# ... check if it's present in the existing steps
	not contains(all_steps, required_step)

	# Show a human-friendly error message
	msg := sprintf("deployment stage '%s' is missing required step '%s'", [stage.name, required_step])
}

# Steps that must be present in every deployment
required_steps = ["Wiz"]

contains(arr, elem) {
	arr[_] = elem
}
