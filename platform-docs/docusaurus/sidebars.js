module.exports = {
  docs: [
    'intro',
    'architecture',
    {
      type: 'category',
      label: 'Workflows',
      items: [
        'workflows/fortify-fod-reusable',
        'workflows/sonatype-sca-reusable',
        'workflows/sonatype-lifecycle-fod-sync',
        'workflows/security-gate',
        'workflows/orchestrator-detector-patterns'
      ]
    },
    {
      type: 'category',
      label: 'Actions',
      items: ['actions/fcli-custom-actions']
    },
    {
      type: 'category',
      label: 'Governance',
      items: ['governance/compliance-rollout', 'governance/enforcement-strategy', 'governance/enforcement-examples', 'governance/enforcement-templates', 'governance/ghes-ruleset-api']
    },
    {
      type: 'category',
      label: 'Agent Skills',
      items: [
        'agent-skills/README',
        'agent-skills/reusable-workflow-onboarding/SKILL',
        'agent-skills/fortify-fod-setup-config/SKILL',
        'agent-skills/sonatype-sca-setup-config/SKILL',
        'agent-skills/security-gate-validation/SKILL',
        'agent-skills/orchestrator-detector-integration/SKILL',
        'agent-skills/governance-template-and-ruleset-operations/SKILL'
      ]
    },
    {
      type: 'category',
      label: 'Publishing',
      items: ['publishing/docusaurus', 'publishing/repository-split', 'publishing/template-sync']
    }
  ]
};
