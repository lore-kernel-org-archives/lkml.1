Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYAOVn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYAOVn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYAOVnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:43:10 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37077
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755013AbYAOVnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:43:08 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 16:43:08 EST
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Add Documentation/x86-64/00-INDEX
Date: Tue, 15 Jan 2008 15:35:05 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, vojtech@suse.cz
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151535.05944.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add Documentation/x86_64/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/x86_64/00-INDEX |   16 ++++++++++++++
 1 file changed, 16 insertions(+)

--- /dev/null
+++ b/Documentation/x86_64/00-INDEX
@@ -0,0 +1,16 @@
+00-INDEX
+	- This file
+boot-options.txt
+	- AMD64-specific boot options.
+cpu-hotplug-spec
+	- Firmware support for CPU hotplug under Linux/x86-64
+fake-numa-for-cpusets
+	- Using numa=fake and CPUSets for Resource Management
+kernel-stacks
+	- Context-specific per-processor interrupt stacks.
+machinecheck
+	- Configurable sysfs parameters for the x86-64 machine check code.
+mm.txt
+	- Memory layout of x86-64 (4 level page tables, 46 bits physical).
+uefi.txt
+	- Booting Linux via Unified Extensible Firmware Interface.

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
