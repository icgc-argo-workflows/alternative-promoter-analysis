FROM alternative-promoter-analysis.alternative-promoter-proactiv:0.1.0

LABEL org.opencontainers.image.source https://github.com/icgc-argo-rna-wg/alternative-promoter-analysis

ENV PATH="/tools:${PATH}"

COPY *.py /tools/

ENTRYPOINT ["/usr/bin/env"]

CMD ["/bin/bash"]
