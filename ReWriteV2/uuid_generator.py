import uuid
import re

def updateUUID():
    with open('ApexRW.ahk', "r") as f:
        content = f.read()

    new_uuid_str = 'Global UUID := "' + uuid.uuid4().hex + '"'

    content_new = re.sub('Global UUID := ".+"', new_uuid_str, content)

    with open('ApexRW.ahk', "w") as f:
        f.write(content_new)


if __name__ == '__main__':
    updateUUID()
