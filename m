Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbZGHF5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbZGHF5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757988AbZGHFzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:55:54 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3009 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbZGHFzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:55:50 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7/7] MAINTAINERS: Update KERNEL JANITORS
Date: Tue,  7 Jul 2009 22:55:45 -0700
Message-Id: <5bb2fa279bcbf854b056b8df8ff4b9f675613b72.1247032324.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247032324.git.joe@perches.com>
References: <cover.1247032324.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ef07f59..73b4b02 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3366,10 +3366,9 @@ F:	Makefile
 F:	scripts/Makefile.*
 
 KERNEL JANITORS
-P:	Several
 L:	kernel-janitors@vger.kernel.org
-W:	http://www.kerneljanitors.org/
-S:	Maintained
+W:	http://janitor.kernelnewbies.org/
+S:	Odd fixes
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 P:	J. Bruce Fields
-- 
1.6.3.1.10.g659a0.dirty

