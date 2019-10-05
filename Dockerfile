FROM genebean/dependabot-ci

WORKDIR /home/dependabot/dependabot-core

COPY updater.rb /home/dependabot/dependabot-core/bin/entrypoint.rb

ENTRYPOINT ["/home/dependabot/dependabot-core/bin/entrypoint.rb"]
