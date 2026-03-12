# Challenge 14 — HCP Terraform Scenario Pack

## Skills Tested
- HCP Terraform run workflow (plan → cost estimation → policy check → apply)
- Workspace configuration (VCS-driven, CLI-driven, API-driven)
- Variable types and precedence in HCP Terraform
- Dynamic provider credentials (OIDC-based)
- Team permissions and organization structure
- Sentinel and OPA policy enforcement
- Run tasks, run triggers, and workspace dependencies
- Private registry and module publishing

## Exam Objectives
- **6a**: HCP Terraform run workflow
- **6b**: Workspace configuration and management
- **6c**: Dynamic credentials and variable management
- **6d**: Policy enforcement (Sentinel/OPA), run tasks, and governance

## Why This Exists
Domain 6 (HCP Terraform) is **multiple-choice only** on the exam — there are no hands-on labs for it. But it still represents a significant portion of the ~12 multiple-choice questions. The existing 8 challenges in this repo focus entirely on open-source Terraform with AWS and provide zero coverage of HCP Terraform concepts. This scenario pack fills that gap with realistic exam-style questions and detailed explanations.

## How to Use This Pack
1. Read each scenario carefully — they mirror the format of actual exam questions
2. Choose your answer before reading the explanation
3. If you get it wrong, note the concept and review the relevant HashiCorp documentation
4. Aim for 90%+ accuracy before sitting the exam

## Estimated Time
60–90 minutes (study and self-quiz)

---

## Scenarios

### Scenario 1: Run Workflow Order

Your team uses HCP Terraform with Sentinel policies and cost estimation enabled. A developer pushes a commit to the VCS repository connected to a workspace.

**In what order do the following steps occur?**

A. Plan → Apply → Policy Check → Cost Estimation
B. Plan → Cost Estimation → Policy Check → Apply
C. Policy Check → Plan → Cost Estimation → Apply
D. Plan → Policy Check → Cost Estimation → Apply

<details>
<summary>Answer</summary>

**B. Plan → Cost Estimation → Policy Check → Apply**

The HCP Terraform run workflow always follows this order:
1. **Plan** — Terraform generates the execution plan
2. **Cost Estimation** — If enabled, HCP Terraform estimates the monthly cost change
3. **Policy Check** — Sentinel or OPA policies are evaluated against the plan
4. **Apply** — If policies pass (or are advisory-only), the apply proceeds

Policy checks happen *after* cost estimation because policies can reference cost data in their rules. This order is fixed and cannot be changed.
</details>

---

### Scenario 2: Workspace Types

You need to set up an HCP Terraform workspace for a team that wants runs triggered automatically when code is pushed to their Git repository. They also want the ability to manually trigger runs from the UI.

**Which workspace type should you configure?**

A. CLI-driven workspace
B. VCS-driven workspace
C. API-driven workspace
D. Agent-driven workspace

<details>
<summary>Answer</summary>

**B. VCS-driven workspace**

VCS-driven workspaces connect directly to a version control repository (GitHub, GitLab, Bitbucket, Azure DevOps). When code is pushed to the connected branch, a run is automatically triggered. VCS-driven workspaces also support manual runs from the UI and API.

- **CLI-driven** workspaces are triggered by running `terraform plan` or `terraform apply` from a local CLI or CI/CD pipeline — they do not auto-trigger from VCS pushes.
- **API-driven** workspaces are triggered only via the HCP Terraform API.
- **Agent-driven** is not a workspace type — agents are a separate feature for private network access.
</details>

---

### Scenario 3: Variable Precedence

An HCP Terraform workspace has the following variable `instance_type` defined in multiple places:

- Workspace variable (HCP Terraform UI): `t2.micro`
- `terraform.tfvars` in the VCS repository: `t2.small`
- Variable set attached to the workspace: `t2.medium`
- `-var` flag in a CLI-triggered run: `t2.large`

**Which value will Terraform use?**

A. `t2.micro` (workspace variable)
B. `t2.small` (terraform.tfvars)
C. `t2.medium` (variable set)
D. `t2.large` (-var flag)

<details>
<summary>Answer</summary>

**D. `t2.large` (-var flag)**

Terraform's variable precedence (from lowest to highest priority) is:
1. Default value in the variable declaration
2. `terraform.tfvars` or `*.auto.tfvars` files
3. Variable sets (HCP Terraform)
4. Workspace-specific variables (HCP Terraform UI/API)
5. `-var` flag or `-var-file` flag on the command line

The `-var` flag always has the highest precedence. In HCP Terraform, workspace variables override variable sets, and both override `.tfvars` files in the repository. This matches the standard Terraform precedence — HCP Terraform workspace variables behave like environment variables or `-var` flags.

Note: If this were a VCS-driven run (no CLI), the workspace variable (`t2.micro`) would win over the variable set and `.tfvars`.
</details>

---

### Scenario 4: Dynamic Provider Credentials

Your security team requires that no long-lived AWS access keys are stored in HCP Terraform workspaces. Instead, they want short-lived credentials that are generated at the start of each run.

**What feature should you configure?**

A. Store AWS credentials as sensitive environment variables in the workspace
B. Configure dynamic provider credentials using OIDC (OpenID Connect)
C. Use a Vault provider data source to fetch credentials at plan time
D. Configure an HCP Terraform agent with an attached IAM role

<details>
<summary>Answer</summary>

**B. Configure dynamic provider credentials using OIDC (OpenID Connect)**

Dynamic provider credentials use OIDC to establish a trust relationship between HCP Terraform and the cloud provider (AWS, Azure, GCP). At the start of each run, HCP Terraform generates a short-lived token that the provider uses to authenticate. No long-lived keys are stored anywhere.

- **Option A** stores long-lived keys — exactly what the security team wants to avoid.
- **Option C** is possible but adds complexity and still requires Vault credentials to be stored somewhere.
- **Option D** is for accessing private networks, not credential management. The agent itself would still need credentials.

To set this up for AWS: create an OIDC identity provider in IAM, create a role with a trust policy that allows HCP Terraform's OIDC issuer, and configure the workspace with the role ARN.
</details>

---

### Scenario 5: Sentinel Policy Enforcement Levels

Your organization has a Sentinel policy that requires all S3 buckets to have encryption enabled. A developer submits a run that creates an S3 bucket without encryption.

**Match each enforcement level with its behavior:**

1. **advisory** — ?
2. **soft-mandatory** — ?
3. **hard-mandatory** — ?

A. The run fails and cannot proceed. No override is possible.
B. The run shows a warning but proceeds to apply automatically.
C. The run fails but an authorized user can override and proceed.

<details>
<summary>Answer</summary>

1. **advisory** → **B** — Shows a warning in the run output but does not block the apply. Used for policies you want visibility on but are not enforcing yet.

2. **soft-mandatory** → **C** — The run fails the policy check, but a user with "Manage Policy Overrides" permission can override and allow the apply to proceed. Used for policies that should be enforced but may have legitimate exceptions.

3. **hard-mandatory** → **A** — The run fails and cannot proceed under any circumstances. No override is possible, not even by organization owners. Used for non-negotiable security or compliance rules.

The exam frequently tests the difference between soft-mandatory and hard-mandatory. The key distinction: soft-mandatory allows authorized overrides, hard-mandatory does not.
</details>

---

### Scenario 6: Run Triggers

You have two HCP Terraform workspaces:
- `network` — manages VPC and subnets
- `application` — manages EC2 instances that depend on the network

You want the `application` workspace to automatically start a new run whenever the `network` workspace completes a successful apply.

**How should you configure this?**

A. Add a `terraform_remote_state` data source in the application workspace
B. Configure a **run trigger** on the `application` workspace with `network` as the source
C. Use a webhook from the VCS repository to trigger both workspaces
D. Configure a **run task** that triggers the application workspace

<details>
<summary>Answer</summary>

**B. Configure a run trigger on the `application` workspace with `network` as the source**

Run triggers create a dependency between workspaces. When the source workspace (`network`) completes a successful apply, the dependent workspace (`application`) automatically queues a new run. This is the built-in mechanism for workspace chaining.

- **Option A** (`terraform_remote_state`) allows reading outputs from another workspace but does NOT trigger runs automatically. It only reads data at plan time.
- **Option C** (VCS webhook) would trigger both workspaces when code changes — not when one workspace applies successfully.
- **Option D** (run tasks) are for integrating external services (security scanners, compliance tools) into the run workflow — they are not for triggering other workspaces.

Note: For run triggers to work, the `application` workspace must be configured to use the `network` workspace as a "source workspace" in its settings.
</details>

---

### Scenario 7: Run Tasks

Your security team wants to integrate a third-party vulnerability scanner (e.g., Snyk or Bridgecrew) into the HCP Terraform workflow. The scanner should analyze the Terraform plan before apply and block the run if critical vulnerabilities are found.

**Which feature should you use?**

A. Sentinel policy
B. Run task
C. Notification webhook
D. Cost estimation

<details>
<summary>Answer</summary>

**B. Run task**

Run tasks integrate external services into the HCP Terraform run workflow. They send the plan data (as JSON) to an external service via a webhook, and the service returns a pass/fail result. Run tasks can be configured to run:
- **Pre-plan**: Before the plan is generated
- **Post-plan**: After the plan but before apply (most common for security scanning)
- **Pre-apply**: Just before the apply step

Run tasks can be **advisory** (warnings only) or **mandatory** (block the run on failure).

- **Option A** (Sentinel) is for writing custom policy logic in HCL or Sentinel language — it runs within HCP Terraform, not in an external service.
- **Option C** (notification webhook) sends notifications about run status but cannot block runs.
- **Option D** (cost estimation) is a built-in feature, not an integration point.

The key distinction: Sentinel = internal policy engine. Run tasks = external service integration.
</details>

---

### Scenario 8: Team Permissions

You are an organization owner in HCP Terraform. You need to grant a junior developer the ability to:
- View workspace runs and state
- Queue plans (but NOT apply)
- Read variables (but not modify them)

**Which built-in permission level is most appropriate?**

A. Read
B. Plan
C. Write
D. Admin

<details>
<summary>Answer</summary>

**B. Plan**

HCP Terraform has four built-in team permission levels for workspaces:

| Permission | Capabilities |
|-----------|-------------|
| **Read** | View runs, state, and variables (read-only) |
| **Plan** | Everything in Read + queue plans (but cannot apply) |
| **Write** | Everything in Plan + apply runs, lock/unlock state |
| **Admin** | Everything in Write + modify workspace settings, manage team access |

The "Plan" level matches exactly: the developer can view runs, read variables, and queue plans — but cannot apply changes. This enforces a review step where someone with Write or Admin must approve the apply.

Custom permissions are also available for more granular control (e.g., allow applying but not state locking), but the exam primarily tests the built-in levels.
</details>

---

### Scenario 9: Private Registry

Your organization has published a custom Terraform module to the HCP Terraform private registry. A developer wants to use this module in their configuration.

**Which module source format should they use?**

A. `source = "github.com/myorg/my-module"`
B. `source = "app.terraform.io/myorg/my-module/aws"`
C. `source = "registry.terraform.io/myorg/my-module/aws"`
D. `source = "./modules/my-module"`

<details>
<summary>Answer</summary>

**B. `source = "app.terraform.io/myorg/my-module/aws"`**

The HCP Terraform private registry uses the `app.terraform.io` hostname. The format is:
```
app.terraform.io/<ORGANIZATION>/<MODULE_NAME>/<PROVIDER>
```

- **Option A** is a GitHub source — it fetches directly from Git, bypassing the registry.
- **Option C** uses the public registry hostname — your private module would not be found there.
- **Option D** is a local path source — only works for modules within the same repository.

To reference a specific version, add a `version` constraint:
```hcl
module "my_module" {
  source  = "app.terraform.io/myorg/my-module/aws"
  version = "~> 1.0"
}
```

Authentication to the private registry happens automatically in HCP Terraform runs. For local CLI usage, you need a `credentials` block in `.terraformrc` or a `TF_TOKEN_app_terraform_io` environment variable.
</details>

---

### Scenario 10: Workspace State Sharing

Two HCP Terraform workspaces need to share data:
- `network` workspace outputs VPC IDs and subnet IDs
- `compute` workspace needs to read those outputs

**Which approach does HCP Terraform recommend over `terraform_remote_state`?**

A. Use the `tfe_outputs` data source from the `tfe` provider
B. Store outputs in an S3 bucket and read them with the `aws_s3_object` data source
C. Use Consul KV store as an intermediary
D. Hardcode the values as variables in the compute workspace

<details>
<summary>Answer</summary>

**A. Use the `tfe_outputs` data source from the `tfe` provider**

The `tfe_outputs` data source is the recommended way to share data between HCP Terraform workspaces. It reads the outputs of one workspace and makes them available to another:

```hcl
data "tfe_outputs" "network" {
  organization = "myorg"
  workspace    = "network"
}

resource "aws_instance" "web" {
  subnet_id = data.tfe_outputs.network.values.subnet_id
}
```

Benefits over `terraform_remote_state`:
- Does not require backend configuration details (bucket names, keys, etc.)
- Respects HCP Terraform's access controls — the consuming workspace must have permission
- Works across organizations (with proper access grants)
- Only exposes outputs, not the entire state

`terraform_remote_state` still works in HCP Terraform but requires configuring the `remote` backend details explicitly. The `tfe_outputs` approach is simpler and more secure.
</details>

---

### Scenario 11: Speculative Plans

A developer opens a pull request against a repository connected to an HCP Terraform VCS-driven workspace.

**What happens automatically?**

A. A full plan and apply runs against the workspace
B. A speculative plan runs that shows what would change, but does not apply
C. Nothing happens until the PR is merged
D. A cost estimation runs but no plan is generated

<details>
<summary>Answer</summary>

**B. A speculative plan runs that shows what would change, but does not apply**

When a pull request is opened against a VCS-connected workspace, HCP Terraform automatically runs a **speculative plan**. This plan:
- Shows what resources would be created, changed, or destroyed
- Runs Sentinel/OPA policy checks (if configured)
- Posts the results as a check/status on the PR
- **Cannot be applied** — it is informational only

The full plan-and-apply cycle only triggers when the PR is merged to the connected branch (or when manually triggered). This gives reviewers visibility into infrastructure changes before merging.

Speculative plans also run cost estimation and policy checks, giving the team full visibility into the impact of the proposed change.
</details>

---

### Scenario 12: No-Code Provisioning

Your platform team wants to allow application developers to provision pre-approved infrastructure (e.g., a standard S3 bucket with encryption and logging) without writing any Terraform code.

**Which HCP Terraform feature enables this?**

A. Variable sets
B. No-code provisioning (module-based workspaces)
C. Run tasks
D. Policy sets

<details>
<summary>Answer</summary>

**B. No-code provisioning (module-based workspaces)**

No-code provisioning in HCP Terraform allows organization admins to publish modules to the private registry and make them available as self-service "no-code ready" modules. Application developers can then create workspaces from these modules through the UI — filling in variables through a form — without writing any HCL.

This provides:
- **Standardization** — the platform team controls the module design
- **Self-service** — developers don't need Terraform knowledge
- **Governance** — Sentinel policies still apply to the resulting runs

- **Variable sets** share variables across workspaces but don't provision anything.
- **Run tasks** integrate external services, not self-service provisioning.
- **Policy sets** enforce rules but don't provide templates for provisioning.
</details>

---

### Scenario 13: Agent Pools

Your organization's infrastructure runs in a private network that is not accessible from the public internet. HCP Terraform needs to apply Terraform configurations that manage resources in this private network.

**What should you configure?**

A. A VPN connection between HCP Terraform and your private network
B. An HCP Terraform agent installed in your private network
C. A proxy server that forwards HCP Terraform traffic
D. IP allowlisting for HCP Terraform's public IP addresses

<details>
<summary>Answer</summary>

**B. An HCP Terraform agent installed in your private network**

HCP Terraform agents are lightweight, long-running processes that you install inside your private network. They:
- Poll HCP Terraform for pending runs assigned to their agent pool
- Execute `terraform plan` and `terraform apply` from within your network
- Can access private resources (databases, internal APIs, VPC endpoints)
- Send results back to HCP Terraform over an outbound HTTPS connection

This means your private network only needs **outbound** internet access to HCP Terraform — no inbound ports need to be opened.

Agent pools are configured at the organization level and assigned to specific workspaces. Each workspace can use either HCP Terraform's default execution environment or a custom agent pool.

- **Option A** (VPN) is not supported — HCP Terraform doesn't offer direct VPN connectivity.
- **Option C** (proxy) would require complex setup and is not an official pattern.
- **Option D** (IP allowlisting) doesn't help when resources are in a private network with no public endpoints.
</details>

---

### Scenario 14: Drift Detection

Your organization wants HCP Terraform to automatically detect when infrastructure has been modified outside of Terraform (e.g., manual changes in the AWS console).

**Which feature provides this?**

A. Run triggers
B. Health assessments (drift detection)
C. State versioning
D. Speculative plans

<details>
<summary>Answer</summary>

**B. Health assessments (drift detection)**

HCP Terraform's health assessments feature includes **drift detection** that automatically runs periodic refresh-only plans to compare the actual infrastructure state with the Terraform state. When drift is detected:
- The workspace is flagged with a drift notification
- You can view exactly which attributes have changed
- You can choose to reconcile (run an apply) or accept the drift

Health assessments also include **continuous validation**, which re-evaluates `check` blocks and postconditions periodically.

- **Run triggers** connect workspaces but don't detect drift.
- **State versioning** stores historical state but doesn't actively compare.
- **Speculative plans** show proposed changes from code, not actual infrastructure drift.

Note: Drift detection is available on HCP Terraform Plus tier and above.
</details>

---

### Scenario 15: Workspace Execution Mode

You are migrating from open-source Terraform to HCP Terraform. Your CI/CD pipeline currently runs `terraform plan` and `terraform apply` locally. You want to keep using your existing pipeline but store state in HCP Terraform.

**Which execution mode should you configure?**

A. Remote execution (default)
B. Local execution
C. Agent execution
D. CLI-driven execution

<details>
<summary>Answer</summary>

**B. Local execution**

When a workspace is set to **local execution mode**, HCP Terraform only manages the state — it stores and locks the state file, but all Terraform operations (init, plan, apply) run on the local machine or CI/CD runner. This is ideal for migration scenarios where you want to:
- Keep your existing CI/CD pipeline
- Benefit from HCP Terraform's state management, locking, and versioning
- Gradually adopt remote execution later

**Remote execution** (default) runs plan and apply on HCP Terraform's infrastructure. Your CI/CD pipeline would only trigger runs, not execute them.

**Agent execution** runs operations on a self-hosted agent, not locally.

**CLI-driven** is not an execution mode — it's a workspace trigger type (how runs are initiated, not where they execute). CLI-driven workspaces can use either remote or local execution mode.
</details>

---

### Scenario 16: Cost Estimation

A developer runs a plan in HCP Terraform that creates 5 new EC2 instances. Cost estimation shows the estimated monthly cost increase.

**Which of the following is TRUE about HCP Terraform cost estimation?**

A. Cost estimation blocks the run if the estimated cost exceeds a threshold
B. Cost estimation data can be referenced in Sentinel policies to enforce budget limits
C. Cost estimation calculates exact costs including data transfer and API calls
D. Cost estimation requires connecting a cloud billing account

<details>
<summary>Answer</summary>

**B. Cost estimation data can be referenced in Sentinel policies to enforce budget limits**

HCP Terraform's cost estimation integrates with Sentinel, allowing you to write policies like "block any run that increases monthly cost by more than $500." The cost data is available in the Sentinel `tfrun` import:

```sentinel
import "tfrun"

delta_monthly_cost = tfrun.cost_estimate.delta_monthly_cost
main = rule { delta_monthly_cost < 500 }
```

- **Option A** is wrong — cost estimation alone doesn't block runs. You need a Sentinel policy to enforce thresholds.
- **Option C** is wrong — cost estimation provides estimates based on known pricing for compute, storage, etc. It does NOT include data transfer, API calls, or variable costs.
- **Option D** is wrong — cost estimation uses public pricing data and does not require a billing account connection.

Cost estimation runs automatically in the run workflow (after plan, before policy check) and is available on all HCP Terraform tiers.
</details>

---

### Scenario 17: Organization-Level Variable Sets

Your organization has 50 workspaces across 10 teams. All workspaces need the same AWS region and common tags applied.

**What is the most efficient way to share these variables?**

A. Define the variables in each workspace individually
B. Create a variable set scoped to the entire organization
C. Use a `terraform.tfvars` file committed to every repository
D. Create a shared module that defines the variables as locals

<details>
<summary>Answer</summary>

**B. Create a variable set scoped to the entire organization**

Variable sets in HCP Terraform allow you to define variables once and share them across multiple workspaces. They can be scoped to:
- **Entire organization** — applies to all workspaces
- **Specific projects** — applies to all workspaces in selected projects
- **Specific workspaces** — applies to selected workspaces only

This is the most efficient approach for organization-wide settings like region defaults and common tags. When the value needs to change, you update it in one place.

- **Option A** works but is tedious and error-prone with 50 workspaces.
- **Option C** requires updating 50+ repositories when values change.
- **Option D** uses `locals` which are not overridable — variables in variable sets can be overridden at the workspace level when exceptions are needed.

Remember: workspace-specific variables override variable set values (higher precedence).
</details>

---

### Scenario 18: State File Access Control

In HCP Terraform, you want to ensure that only the `network` team can view and modify the state of network-related workspaces, while the `application` team can read the outputs but not the full state.

**How should you configure this?**

A. Use workspace-level team permissions — give the network team "Write" and the application team "Read"
B. Use separate organizations for each team
C. Encrypt the state file with a team-specific key
D. Use `remote_state_consumers` to control which workspaces can read the state

<details>
<summary>Answer</summary>

**A and D are both correct and complementary.**

**Team permissions** (Option A) control who can view and modify the workspace, including its state. The "Read" permission allows viewing runs and state, while "Write" allows applying changes.

**Remote state consumers** (Option D) control which *other workspaces* can read the state using `terraform_remote_state` or `tfe_outputs`. By default, only workspaces within the same organization can read each other's state. You can restrict this further by specifying an explicit list of allowed consumer workspaces.

Best practice is to use both:
1. Team permissions for human access control
2. Remote state consumers for workspace-to-workspace access control

- **Option B** (separate organizations) is too heavy-handed and breaks cross-team collaboration.
- **Option C** (custom encryption) is not a feature of HCP Terraform — state is encrypted at rest automatically.
</details>

---

### Scenario 19: Terraform Cloud vs. Terraform Enterprise

Your company requires that all Terraform state and execution happens within your own data center due to regulatory requirements. You still want the full feature set of managed Terraform (remote execution, policy enforcement, private registry).

**Which product should you use?**

A. HCP Terraform (Free tier)
B. HCP Terraform (Plus tier)
C. Terraform Enterprise (self-hosted)
D. Open-source Terraform with an S3 backend

<details>
<summary>Answer</summary>

**C. Terraform Enterprise (self-hosted)**

Terraform Enterprise is the self-hosted version of HCP Terraform. It provides the same feature set — remote execution, policy enforcement, private registry, team management — but runs entirely within your own infrastructure. This satisfies regulatory requirements for data residency and execution locality.

- **Options A and B** (HCP Terraform) are SaaS offerings hosted by HashiCorp — state and execution happen on HashiCorp's infrastructure.
- **Option D** (open-source with S3) gives you state management but no policy enforcement, private registry, team management, or run workflow.

Terraform Enterprise is available as a Kubernetes deployment or a standalone installation. It requires a license from HashiCorp.
</details>

---

### Scenario 20: Sentinel vs. OPA

Your organization is evaluating policy-as-code options for HCP Terraform. Some team members prefer Sentinel (HashiCorp's native language) while others prefer Open Policy Agent (OPA) with Rego.

**Which statement is TRUE?**

A. HCP Terraform supports only Sentinel, not OPA
B. HCP Terraform supports both Sentinel and OPA, and they can be used together on the same workspace
C. OPA policies can only be used as run tasks, not native policy checks
D. Sentinel is being deprecated in favor of OPA

<details>
<summary>Answer</summary>

**B. HCP Terraform supports both Sentinel and OPA, and they can be used together on the same workspace**

HCP Terraform natively supports both policy frameworks:
- **Sentinel** — HashiCorp's policy-as-code language, purpose-built for Terraform. Uses the `tfplan`, `tfstate`, `tfconfig`, and `tfrun` imports.
- **OPA (Rego)** — The open-source policy engine from the CNCF. HCP Terraform evaluates Rego policies against the same plan data.

Both can be configured as policy sets and attached to workspaces. They can even coexist on the same workspace — Sentinel and OPA policy sets are evaluated independently during the policy check phase.

- **Option A** is wrong — OPA support was added to HCP Terraform.
- **Option C** is wrong — OPA is a native policy framework in HCP Terraform, not just a run task.
- **Option D** is wrong — Sentinel is actively maintained and not deprecated.

For the exam, know that both are supported but Sentinel has deeper integration (more imports, more examples in HashiCorp docs).
</details>
