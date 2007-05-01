Return-Path: <linux-kernel-owner+w=401wt.eu-S1423617AbXEAV2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423617AbXEAV2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423663AbXEAV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:28:14 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22695 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423617AbXEAV2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:28:13 -0400
Date: Tue, 1 May 2007 14:30:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, trivial@kernel.org
Subject: [PATCH] doc: fix oops-tracing duplicate
Message-Id: <20070501143009.39abf496.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Remove duplicate 'U' entry -- fix mis-merge.

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 Documentation/oops-tracing.txt |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.21-git4.orig/Documentation/oops-tracing.txt
+++ linux-2.6.21-git4/Documentation/oops-tracing.txt
@@ -234,9 +234,6 @@ characters, each representing a particul
   6: 'B' if a page-release function has found a bad page reference or
      some unexpected page flags.
 
-  7: 'U' if a user specifically requested that the Tainted flag be set,
-     ' ' otherwise.
-
   7: 'U' if a user or user application specifically requested that the
      Tainted flag be set, ' ' otherwise.
 
