Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbZEXCmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbZEXCmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbZEXCiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:50 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1439 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbZEXCiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:05 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/18] MAINTAINERS - Mention scripts/get_maintainer.pl in the preface
Date: Sat, 23 May 2009 19:37:48 -0700
Message-Id: <e96525acc3d3e4f3551b5c5b72541ea43e4e3f13.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0774b87..fbf4580 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -36,6 +36,12 @@ trivial patch so apply some common sense.
 	(scripts/checkpatch.pl) to catch trival style violations.
 	See Documentation/CodingStyle for guidance here.
 
+	PLEASE CC: the maintainers and mailing lists that are generated
+	by scripts/get_maintainer.pl.  The results returned by the
+	script will be best if you have git installed and are making
+	your changes in a branch derived from Linus' latest git tree.
+	See Documentation/SubmittingPatches for details.
+
 	PLEASE try to include any credit lines you want added with the
 	patch. It avoids people being missed off by mistake and makes
 	it easier to know who wants adding and who doesn't.
-- 
1.6.3.1.10.g659a0.dirty

