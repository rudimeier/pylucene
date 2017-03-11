/* ====================================================================
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 * ====================================================================
 */

package org.apache.pylucene.store;

import java.io.IOException;
import org.apache.lucene.store.IndexOutput;


public class PythonIndexOutput extends IndexOutput {

    private long pythonObject;

    public PythonIndexOutput()
    {
    }

    public void pythonExtension(long pythonObject)
    {
        this.pythonObject = pythonObject;
    }
    public long pythonExtension()
    {
        return this.pythonObject;
    }

    public void finalize()
        throws Throwable
    {
        pythonDecRef();
    }

    public native void pythonDecRef();

    public void flush()
        throws IOException
    {}

    public native long getFilePointer();
    public native long getChecksum()
        throws IOException;
    public native void close()
        throws IOException;
    public native void writeByte(byte b)
        throws IOException;
    public native void writeBytes(byte[] bytes)
        throws IOException;

    public void writeBytes(byte[] bytes, int offset, int length)
        throws IOException
    {
        if (offset > 0 || length < bytes.length)
        {
            byte[] data = new byte[length];

            System.arraycopy(bytes, offset, data, 0, length);
            writeBytes(data);
        }
        else
            writeBytes(bytes);
    }
}
