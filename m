Return-Path: <linux-kernel-owner+w=401wt.eu-S1765038AbYESWHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765038AbYESWHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765068AbYESWFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:05:00 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45038 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765043AbYESWE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:04:57 -0400
Date: Tue, 20 May 2008 01:02:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] quota: remove CVS keywords
Message-ID: <20080519220251.GE17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time 
from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/dquot.c               |    2 --
 include/linux/quota.h    |    2 --
 include/linux/quotaops.h |    3 ---
 3 files changed, 7 deletions(-)

f2096053eb97000dbd556a4a2465c879bdf38670 diff --git a/fs/dquot.c b/fs/dquot.c
index 5ac77da..920e430 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -9,8 +9,6 @@
  * implementation is based on one of the several variants of the LINUX
  * inode-subsystem with added complexity of the diskquota system.
  * 
- * Version: $Id: dquot.c,v 6.3 1996/11/17 18:35:34 mvw Exp mvw $
- * 
  * Author:	Marco van Wieringen <mvw@planets.elm.net>
  *
  * Fixes:   Dmitry Gorodchanin <pgmdsg@ibi.com>, 11 Feb 96
diff --git a/include/linux/quota.h b/include/linux/quota.h
index dcddfb2..17eadfd 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -28,8 +28,6 @@
  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE.
- *
- * Version: $Id: quota.h,v 2.0 1996/11/17 16:48:14 mvw Exp mvw $
  */
 
 #ifndef _LINUX_QUOTA_
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index f867020..48e02fc 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -3,9 +3,6 @@
  * macros expand to the right source-code.
  *
  * Author:  Marco van Wieringen <mvw@planets.elm.net>
- *
- * Version: $Id: quotaops.h,v 1.2 1998/01/15 16:22:26 ecd Exp $
- *
  */
 #ifndef _LINUX_QUOTAOPS_
 #define _LINUX_QUOTAOPS_

