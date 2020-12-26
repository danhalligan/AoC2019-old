class intcode:
    def __init__(self, str):
        self.data = [int(x) for x in str.split(',')]
