local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('iot.kapua', 'eclipse-kapua') {
  settings+: {
    description: "",
    name: "Eclipse Kapua™",
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
  secrets+: [
    orgs.newOrgSecret('GPG_KEY_ID') {
      value: "pass:bots/iot.kapua/gpg/key_id",
    },
    orgs.newOrgSecret('GPG_PASSPHRASE') {
      value: "pass:bots/iot.kapua/gpg/passphrase",
    },
    orgs.newOrgSecret('GPG_PRIVATE_KEY') {
      value: "pass:bots/iot.kapua/gpg/secret-subkeys.asc",
    },
    orgs.newOrgSecret('CENTRAL_SONATYPE_TOKEN_PASSWORD') {
      value: "pass:bots/iot.kapua/central.sonatype.org/token-password",
    },
    orgs.newOrgSecret('CENTRAL_SONATYPE_TOKEN_USERNAME') {
      value: "pass:bots/iot.kapua/central.sonatype.org/token-username",
    },
  ],
  webhooks+: [
    orgs.newOrgWebhook('https://ci.eclipse.org/kapua/github-webhook/') {
      content_type: "json",
      events+: [
        "pull_request",
        "push"
      ],
    },
  ],
  _repositories+:: [
    orgs.newRepo('kapua') {
      allow_merge_commit: true,
      allow_update_branch: false,
      code_scanning_default_languages+: [
        "actions",
        "javascript-typescript",
      ],
      code_scanning_default_setup_enabled: true,
      default_branch: "develop",
      delete_branch_on_merge: false,
      dependabot_security_updates_enabled: true,
      topics+: [
        "eclipseiot",
        "internet-of-things"
      ],
      webhooks: [
        orgs.newRepoWebhook('https://notify.travis-ci.org') {
          events+: [
            "create",
            "delete",
            "issue_comment",
            "member",
            "public",
            "pull_request",
            "push",
            "repository"
          ],
        },
        orgs.newRepoWebhook('https://webhooks.gitter.im/e/90265add547aa449c92d') {
          content_type: "json",
          events+: [
            "*"
          ],
        },
      ],
      secrets: [
        orgs.newRepoSecret('CODECOV_TOKEN') {
          value: "********",
        },
        orgs.newRepoSecret('KAPUA_GITLAB_API_TOKEN') {
          value: "pass:bots/iot.kapua/gitlab.eclipse.org/api-token",
        },
        orgs.newRepoSecret('SONAR_TOKEN') {
          value: "pass:bots/iot.kapua/sonarcloud.io/token",
        },
      ],
      rulesets: [
        orgs.newRepoRuleset('develop') {
          allows_creations: true,
          enforcement: "disabled",
          required_pull_request: null,
          required_status_checks: null,
        },
      ],
    },
  ],
} + {
  # snippet added due to 'https://github.com/EclipseFdn/otterdog-configs/blob/main/blueprints/add-dot-github-repo.yml'
  _repositories+:: [
    orgs.newRepo('.github')
  ],
}