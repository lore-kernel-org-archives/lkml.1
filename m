Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab0CAQav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:30:51 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34637
	"EHLO grelber.thyrsus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751071Ab0CAQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:30:50 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: trivial@rustcorp.com.au
Subject: [PATCH] Documentation/filesystems/proc.txt typo fix.
Date: Mon, 1 Mar 2010 10:30:43 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-18-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003011030.43877.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Typo fix for a filename in procfs documentation.

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/filesystems/proc.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 0d07513..14e6d29 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -297,7 +297,7 @@ Table 1-4: Contents of the stat files (as of 2.6.30-rc7)
   cgtime        guest time of the task children in jiffies
 ..............................................................................
 
-The /proc/PID/map file containing the currently mapped memory regions and
+The /proc/PID/maps file containing the currently mapped memory regions and
 their access permissions.
 
 The format is:

-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
