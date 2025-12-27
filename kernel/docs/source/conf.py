# -- Project information -----------------------------------------------------

project = 'Zeronix Kernel'
copyright = '2025, Viktor Popp'
author = 'Viktor Popp'

# -- General configuration ---------------------------------------------------

extensions = ['breathe', 'exhale']

templates_path = ['_templates']
exclude_patterns = []

# -- Exhale configuration ----------------------------------------------------

breathe_projects = {
    "Kernel": "../output/xml"
}

breathe_default_project = "Kernel"

exhale_args = {
    "containmentFolder":     "./gen",
    "rootFileName":          "gen_root.rst",
    "rootFileTitle":         "Source Documentation",
    "doxygenStripFromPath":  "..",
    "createTreeView":        True,
}

primary_domain = 'c'
highlight_language = 'c'

# -- Options for HTML output -------------------------------------------------

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
