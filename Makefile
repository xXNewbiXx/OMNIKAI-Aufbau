.PHONY: sanity check-json check-markdown

check-json:
	bash scripts/sanity/check-json.sh

check-markdown:
	bash scripts/sanity/check-markdown.sh

sanity: check-json check-markdown
