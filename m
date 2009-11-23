Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbZKWRAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbZKWRAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZKWRAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:00:20 -0500
Received: from mail2.microsoft.com ([131.107.115.215]:23462 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZKWRAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:00:19 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'gregkh@suse.de'" <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: hv: Fix some missing author names
Thread-Topic: [PATCH] Staging: hv: Fix some missing author names
Thread-Index: AQHKbF5yMVoMJ9MaM06P3jFcr9P/mw==
Date: Mon, 23 Nov 2009 17:00:22 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7230C8352F@TK5EX14MBXC126.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Fix some missing author names. 
They were accidentally removed previously.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
diff --git a/drivers/staging/hv/BlkVsc.c b/drivers/staging/hv/BlkVsc.c
index 51aa861..a48ee3a 100644
--- a/drivers/staging/hv/BlkVsc.c
+++ b/drivers/staging/hv/BlkVsc.c
@@ -16,6 +16,7 @@
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
  * Authors:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  *
  */
diff --git a/drivers/staging/hv/NetVsc.c b/drivers/staging/hv/NetVsc.c
index d384c0d..1c717f9 100644
--- a/drivers/staging/hv/NetVsc.c
+++ b/drivers/staging/hv/NetVsc.c
@@ -15,6 +15,7 @@
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
  * Authors:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
 #include <linux/kernel.h>
diff --git a/drivers/staging/hv/NetVsc.h b/drivers/staging/hv/NetVsc.h
index 3e7112f..6e0e034 100644
--- a/drivers/staging/hv/NetVsc.h
+++ b/drivers/staging/hv/NetVsc.h
@@ -16,6 +16,7 @@
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
  * Authors:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  *
  */
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 99c4926..62b2828 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -15,6 +15,7 @@
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
  * Authors:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
 #include <linux/init.h>
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 3192d50..0d7459e 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -15,6 +15,7 @@
  * Place - Suite 330, Boston, MA 02111-1307 USA.
  *
  * Authors:
+ *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
 #include <linux/init.h>
