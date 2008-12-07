Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYLGSbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYLGSbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYLGSa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:30:59 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55688 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbYLGSa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:30:58 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 01/13] checkpatch: update MAINTAINERS entry
Date: Sun,  7 Dec 2008 18:30:38 +0000
Message-Id: <1228674650-24392-2-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update my email address to my new work address.  Also, as per our recent
email conversation remove Randy and Joel from the maintainers list.
Finally add LKML so that emails are recorded somewhere.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joel Schopp <jschopp@austin.ibm.com>
---
 MAINTAINERS |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 618c1ef..0d587ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1091,11 +1091,8 @@ S:	Maintained
 
 CHECKPATCH
 P:	Andy Whitcroft
-M:	apw@shadowen.org
-P:	Randy Dunlap
-M:	rdunlap@xenotime.net
-P:	Joel Schopp
-M:	jschopp@austin.ibm.com
+M:	apw@canonical.com
+L:	linux-kernel@vger.kernel.org
 S:	Supported
 
 CISCO 10G ETHERNET DRIVER
-- 
1.6.0.4.911.gc990

