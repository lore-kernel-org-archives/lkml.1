Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbZEXClf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbZEXClf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbZEXCig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:36 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1440 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbZEXCie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:34 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 18/18] MAINTAINERS - Add file pattern to CISCO FCOE HBA DRIVER
Date: Sat, 23 May 2009 19:37:49 -0700
Message-Id: <ef0cdda5ec46ecb8a82287ceb5babd0da0de9ca2.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fbf4580..ab45488 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1434,6 +1434,7 @@ P:	Joe Eykholt
 M:	jeykholt@cisco.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	drivers/scsi/fnic/
 
 CODA FILE SYSTEM
 P:	Jan Harkes
-- 
1.6.3.1.10.g659a0.dirty

