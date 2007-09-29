Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXI2AxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXI2AxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbXI2AxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:53:16 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49990
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755029AbXI2AxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:53:15 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation/x86_64/00-INDEX (right path this time)
Date: Fri, 28 Sep 2007 19:53:12 -0500
User-Agent: KMail/1.9.6
Cc: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org, vojtech@suse.cz
References: <200709281944.02953.rob@landley.net>
In-Reply-To: <200709281944.02953.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281953.12375.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add Documentation/x86_64/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
---

Trying again with the right path...

 x86_64/00-INDEX |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ b/Documentation/x86_64/00-INDEX	2007-09-28 19:40:56.000000000 -0500
@@ -0,0 +1,14 @@
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

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
