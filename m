Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbXJKWXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbXJKWXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbXJKWXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:23:45 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46901
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbXJKWXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:23:44 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add Documentation/RCU/00-Index
Date: Thu, 11 Oct 2007 18:23:27 -0500
User-Agent: KMail/1.9.6
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710111823.27396.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add Documentation/RCU/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/RCU/00-INDEX |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ hg/Documentation/RCU/00-INDEX	2007-10-11 18:17:26.000000000 -0500
@@ -0,0 +1,22 @@
+00-INDEX
+	- This file
+arrayRCU.txt
+	- Using RCU to Protect Read-Mostly Arrays
+checklist.txt
+	- Review Checklist for RCU Patches
+listRCU.txt
+	- Using RCU to Protect Read-Mostly Linked Lists
+NMI-RCU.txt
+	- Using RCU to Protect Dynamic NMI Handlers
+rcuref.txt
+	- Reference-count design for elements of lists/arrays protected by RCU
+rcu.txt
+	- RCU Concepts
+RTFP.txt
+	- List of RCU papers (bibliography) going back to 1980.
+torture.txt
+	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
+UP.txt
+	- RCU on Uniprocessor Systems
+whatisRCU.txt
+	- What is RCU?

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
