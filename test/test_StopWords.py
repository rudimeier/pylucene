# ====================================================================
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
# ====================================================================

import sys, lucene, unittest

from java.io import StringReader
from org.apache.lucene.analysis.core import StopFilter
from org.apache.lucene.analysis.standard import StandardTokenizer
from org.apache.lucene.util import Version


# run with -loop to test fix for string local ref leak reported
# by Aaron Lav.

class StopWordsTestCase(unittest.TestCase):

    def setUp(self):

        stopWords = ['the', 'and', 's']
        self.stop_set = StopFilter.makeStopSet(Version.LUCENE_CURRENT,
                                               stopWords)
        self.reader = StringReader('foo')

    def testStopWords(self):

        try:
            result = StandardTokenizer(Version.LUCENE_CURRENT, self.reader)
            result = StopFilter(Version.LUCENE_CURRENT, result, self.stop_set)
        except Exception as e:
            self.fail(str(e))


if __name__ == "__main__":
    lucene.initVM(vmargs=['-Djava.awt.headless=true'])
    if '-loop' in sys.argv:
        sys.argv.remove('-loop')
        while True:
            try:
                unittest.main()
            except:
                pass
    else:
         unittest.main()
