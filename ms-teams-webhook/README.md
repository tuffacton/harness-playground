# MS Teams Webhooks

Library of CI/CD code for MS Teams-related webhooks.

It is really helpful to develop in VS Code with this extension to preview your adaptive card as it would show up in MS Teams or any other products that support adaptive cards:
https://marketplace.visualstudio.com/items?itemName=madewithcardsio.adaptivecardsstudiobeta 

The [CI Update](CI_Update.json) example is a Harness CI example that sends a summarization of Playwright results: https://playwright.dev/docs/test-reporters

The [Playwright Example Pipeline](Playwright_Teams_Pipeline.yaml) is a full Harness pipeline that runs in Harness Cloud and can send the results to MS Teams.

My recommendation is to throw this in a basic Harness `Run` step like so (thank you [Stack Overflow](https://stackoverflow.com/a/36778045) for help finding an ideal method!)

```shell
# Extract results from previous tests JSON
EXPECTED=$(jq -r '.stats.expected' /harness/test-results.json)
SKIPPED=$(jq -r '.stats.skipped' /harness/test-results.json)
UNEXPECTED=$(jq -r '.stats.unexpected' /harness/test-results.json)
FLAKY=$(jq -r '.stats.flaky' /harness/test-results.json)
# Save the date and time this step is approximately started
DATETIME=$(date "+%d/%m/%Y %I:%M %p")

# Send and Adaptive Card to MS Teams Webhook
curl -X POST <+variable.MS_Teams_Test_Webhook_URL> \
-H 'Content-Type: application/json' \
--data-binary @- << EOF
{
    "type": "AdaptiveCard",
    "body": [
        {
            "type": "TextBlock",
            "size": "Large",
            "weight": "Bolder",
            "text": "Harness CI - Playwright Test Results"
        },
        {
            "type": "ColumnSet",
            "columns": [
                {
                    "type": "Column",
                    "items": [
                        {
                            "type": "Image",
                            "url": "https://developer.harness.io/img/icon_ci.svg",
                            "altText": "Harness CI",
                            "size": "Small"
                        }
                    ],
                    "width": "auto"
                },
                {
                    "type": "Column",
                    "items": [
                        {
                            "type": "TextBlock",
                            "weight": "Bolder",
                            "text": "Harness CI",
                            "wrap": true
                        },
                        {
                            "type": "TextBlock",
                            "spacing": "None",
                            "text": "$DATETIME",
                            "isSubtle": true,
                            "wrap": true
                        }
                    ],
                    "width": "stretch"
                }
            ]
        },
        {
            "type": "TextBlock",
            "text": "Results from playwright toolset",
            "wrap": true
        },
        {
            "type": "FactSet",
            "facts": [
                {
                    "title": "Expected:",
                    "value": "$EXPECTED"
                },
                {
                    "title": "Skipped:",
                    "value": "$SKIPPED"
                },
                {
                    "title": "Unexpected:",
                    "value": "$UNEXPECTED"
                },
                {
                    "title": "Flaky:",
                    "value": "$FLAKY"
                }
            ]
        }
    ],
    "actions": [
        {
            "type": "Action.OpenUrl",
            "title": "View Pipeline Execution",
            "url": "<+pipeline.executionUrl>"
        }
    ],
    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
    "version": "1.5"
}
EOF
```