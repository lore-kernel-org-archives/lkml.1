Return-Path: <linux-kernel-owner+w=401wt.eu-S966609AbXEKTy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966609AbXEKTy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030915AbXEKTo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:44:56 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:46667 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965148AbXEKToy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:44:54 -0400
Message-ID: <4644C7B4.4040006@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:44:52 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: lib/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fix in lib/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 lib/kernel_lock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index e0fdfdd..f73e2f8 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -2,7 +2,7 @@
  * lib/kernel_lock.c
  *
  * This is the traditional BKL - big kernel lock. Largely
- * relegated to obsolescense, but used by various less
+ * relegated to obsolescence, but used by various less
  * important (or lazy) subsystems.
  */
 #include <linux/smp_lock.h>
-- 
1.5.0.1

-- 
Simon Arlott
