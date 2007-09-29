Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbXI2AZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbXI2AZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbXI2AZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:25:33 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38891
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752310AbXI2AZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:25:32 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Remove nonstandard line break from Documentation/powerpc/00-INDEX
Date: Fri, 28 Sep 2007 19:25:28 -0500
User-Agent: KMail/1.9.6
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281925.28532.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Remove nonstandard line break from Documentation/powerpc/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
---

This is the only instance of a newline in a 00-INDEX file description, and
it confuses my 00-INDEX > index.html converter.

 Documentation/powerpc/00-INDEX |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -r dc28e4e17791 Documentation/powerpc/00-INDEX
--- a/Documentation/powerpc/00-INDEX	Wed Sep 26 15:52:17 2007 -0700
+++ b/Documentation/powerpc/00-INDEX	Fri Sep 28 19:21:20 2007 -0500
@@ -6,8 +6,7 @@ 00-INDEX
 00-INDEX
 	- this file
 cpu_features.txt
-	- info on how we support a variety of CPUs with minimal compile-time
-	options.
+	- info on how we support a variety of CPUs with minimal compile-time options.
 eeh-pci-error-recovery.txt
 	- info on PCI Bus EEH Error Recovery
 hvcs.txt

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
