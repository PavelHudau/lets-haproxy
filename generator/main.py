import os

from mako.template import Template

TEMPLATES = "../templates"


class Model:
    def __init__(self):
        self.application_name = "my-web-app"
        self.web_domain = "my-web-app.com"


class TemplateWalker:
    def __init__(self, root_dir):
        self.root_dir = root_dir

    def run(self, model):
        for dir_name, sub_dirs, files in os.walk(self.root_dir):
            print(f'Working in directory: {dir_name}')
            for file_name in files:
                print(f'\t Working on file: {file_name}')
                template = Template(filename=os.path.abspath(os.path.join(dir_name, file_name)))
                print(template.render(model=model))


if __name__ == "__main__":
    template_walker = TemplateWalker(TEMPLATES)
    template_walker.run(Model())
