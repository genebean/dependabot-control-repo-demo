# Dependabot Control Repo Demo

This repo demonstrates using [Dependabot](https://dependabot.com) with a [Puppet](https://puppet.com/) control repository. It analyzes both the Gemfile and the Puppetfile and submits pull requests for any entries in either that are out of date.

## Prep

First you will have to build a variation of Dependabot's [Dockerfile.ci](https://github.com/dependabot/dependabot-core/blob/master/Dockerfile.ci) file that includes the code from [PR 1287](https://github.com/dependabot/dependabot-core/pull/1287). The steps to do that are:

1. Clone https://github.com/jpogran/dependabot-core.git
2. `cd` into `dependabot-core` and checkout the branch named `puppet-langauge-support`
3. Build the base containers:

   ```bash
   docker build -t dependabot/dependabot-core . # this may take a while
   cat ../dependabot-control-repo-demo/deps/Dockerfile.ci > Dockerfile.ci
   docker build -f Dockerfile.ci -t genebean/dependabot-ci .
   ```

4. Build this container:

   ```bash
   cd ../dependabot-control-repo-demo
   docker build -t genebean/dependabot-control-repo-demo .
   ```

## Usage

> NOTE: There may still be some edge cases where things blow up... if you find such a case it would be a big help if you'd comment on [PR 1287](https://github.com/dependabot/dependabot-core/pull/1287).

To use the `dependabot/dependabot-control-repo-demo` container you are going to need a token for GitHub or whatever source control system you are using. For sources other than GitHub you will need to look in `updater.rb` for details.

Once you have your token you can export it without it ending up in your shell history like so:

```bash
read -s LOCAL_GITHUB_ACCESS_TOKEN
```

After that you can give it a go like so using either my sample repo or one of your own.

### Running with defaults

```bash
docker run -e LOCAL_GITHUB_ACCESS_TOKEN=$LOCAL_GITHUB_ACCESS_TOKEN -e PROJECT_PATH='genebean/dependabot-test-control-repo' -it --rm genebean/dependabot-control-repo-demo
```

### Running just for a Puppetfile

```bash
docker run -e LOCAL_GITHUB_ACCESS_TOKEN=$LOCAL_GITHUB_ACCESS_TOKEN -e PACKAGE_MANAGER='puppet' -e PROJECT_PATH='genebean/dependabot-test-control-repo' -it --rm genebean/dependabot-control-repo-demo
```

### Running with other checks

The `PACKAGE_MANAGER` environment variable is a comma-separated list that defaults to `bundler,puppet`. If you have other supported files in your control repos you could adjust this list to include those too.

## Vagrant

If, like me, you'd prefer to not run all this locally on your laptop then this is the section for you! This repo contains a Vagrantfile that preps everything so that all you have to do is run it against your repository. Just run `vagrant up` from inside this directory to build everything. When it finishes run `vagrant ssh` and then follow the usage directions above.

## Expected output

Here is a sample of the output when run in Vagrant:

```bash
~ » read -s LOCAL_GITHUB_ACCESS_TOKEN

~ » docker run -e LOCAL_GITHUB_ACCESS_TOKEN=$LOCAL_GITHUB_ACCESS_TOKEN -e PROJECT_PATH='genebean/dependabot-test-control-repo' -it --rm genebean/dependabot-control-repo-demo 
warning: parser/current is loading parser/ruby26, which recognizes
warning: 2.6.5-compliant syntax, but you are running 2.6.2.
warning: please see https://github.com/whitequark/parser#compatibility-with-ruby-mri.
Fetching bundler dependency files for genebean/dependabot-test-control-repo
Parsing dependencies information
  - Updating hiera-eyaml (from )… submitted
  - Updating puppet-lint-legacy_facts-check (from )… submitted
  - Updating puppet-lint-top_scope_facts-check (from )… submitted
  - Updating puppet-lint-unquoted_string-check (from )… submitted
  - Updating cri (from )… submitted
Fetching puppet dependency files for genebean/dependabot-test-control-repo
Parsing dependencies information
  - Updating puppetlabs-apt (from 6.3.0)… submitted
  - Updating puppetlabs-stdlib (from 5.2.0)… submitted
  - Updating puppetlabs-concat (from 4.2.1)… submitted
  - Updating puppetlabs-firewall (from 1.15.1)… submitted
  - Updating puppetlabs-inifile (from 2.5.0)… submitted
  - Updating puppetlabs-reboot (from 2.1.2)… submitted
  - Updating puppetlabs-powershell (from 2.2.0)… submitted
  - Updating puppetlabs-translate (from 1.2.0)… submitted
  - Updating herculesteam-augeasproviders_core (from 2.2.0)… submitted
  - Updating herculesteam-augeasproviders_ssh (from 3.1.0)… submitted
  - Updating puppet-archive (from 3.2.1)… submitted
  - Updating stm-debconf (from 2.3.0)… submitted
  - Updating saz-timezone (from 5.0.2)… submitted
Done
```
