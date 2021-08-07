from mrjob.job import MRJob

class MRWordCount(MRJob):

    def mapper(self, _, line):
        yield "chars", len(line)
        #yield "words", len(line.split())
        yield "words", len(line.replace(" ", ""))
        yield "lines", 1

    def reducer(self, key, values):
        yield key, sum(values)


if __name__ == '__main__':
    MRWordCount.run()
