Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXJBDo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXJBDo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 23:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXJBDov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 23:44:51 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51416
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751985AbXJBDou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 23:44:50 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Add Documentation/power/00-INDEX
Date: Mon, 1 Oct 2007 22:44:46 -0500
User-Agent: KMail/1.9.6
Cc: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       pavel@suse.cz, rjw@sisk.pl
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710012244.46869.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add Documentation/power/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
---
All my pending 00-INDEX patches are at http://landley.net/kdocs/make/patches

 Documentation/power/00-INDEX |   34 +++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ hg/Documentation/power/00-INDEX	2007-10-01 22:35:36.000000000 -0500
@@ -0,0 +1,34 @@
+00-INDEX
+	- This file
+basic-pm-debugging.txt
+	- Debugging suspend and resume
+devices.txt
+	- How drivers interact with system-wide power management
+drivers-testing.txt
+	- Testing suspend and resume support in device drivers
+freezing-of-tasks.txt
+	- How processes and controlled during suspend
+interface.txt
+	- Power management user interface in /sys/power
+notifiers.txt
+	- Registering suspend notifiers in device drivers
+pci.txt
+	- How the PCI Subsystem Does Power Management
+s2ram.txt
+	- How to get suspend to ram working (and debug it when it isn't)
+states.txt
+	- System power management states
+swsusp-and-swap-files.txt
+	- Using swap files with software suspend (to disk)
+swsusp-dmcrypt.txt
+	- How to use dm-crypt and software suspend (to disk) together
+swsusp.txt
+	- Goals, implementation, and usage of software suspend (ACPI S3)
+tricks.txt
+	- How to trick software suspend (to disk) into working when it isn't
+userland-swsusp.txt
+	- Experimental implementation of software suspend in userspace
+video_extension.txt
+	- ACPI video extensions
+video.txt
+	- Video issues during resume from suspend

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
