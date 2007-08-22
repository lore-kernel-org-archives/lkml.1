Return-Path: <linux-kernel-owner+w=401wt.eu-S932843AbXHVWXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbXHVWXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934406AbXHVWWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:22:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:45199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934639AbXHVWWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:22:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Qi Yong <qiyong@fc-cn.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/5] HOWTO: latest lxr url address changed
Date: Wed, 22 Aug 2007 15:10:19 -0700
Message-Id: <11878206493042-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.rc5
In-Reply-To: <11878206353562-git-send-email-gregkh@suse.de>
References: <20070822220747.GA30603@kroah.com>
 <1187820620110-git-send-email-gregkh@suse.de>
 <11878206273940-git-send-email-gregkh@suse.de>
 <11878206353562-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qi Yong <qiyong@fc-cn.com>

Hello,

I've noticed that in Document/HOWTO the url address:
http://sosdg.org/~coywolf/lxr/
has changed to
http://users.sosdg.org/~qiyong/lxr/
from the website.

	-- qiyong

Signed-off-by: Qi Yong <qiyong@fc-cn.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/HOWTO             |    4 ++--
 Documentation/SubmittingPatches |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index f8cc3f8..c64e969 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -208,7 +208,7 @@ tools.  One such tool that is particularly recommended is the Linux
 Cross-Reference project, which is able to present source code in a
 self-referential, indexed webpage format. An excellent up-to-date
 repository of the kernel code may be found at:
-	http://sosdg.org/~coywolf/lxr/
+	http://users.sosdg.org/~qiyong/lxr/
 
 
 The development process
@@ -384,7 +384,7 @@ One of the best ways to put into practice your hacking skills is by fixing
 bugs reported by other people. Not only you will help to make the kernel
 more stable, you'll learn to fix real world problems and you will improve
 your skills, and other developers will be aware of your presence. Fixing
-bugs is one of the best ways to earn merit amongst the developers, because
+bugs is one of the best ways to get merits among other developers, because
 not many people like wasting time fixing other people's bugs.
 
 To work in the already reported bug reports, go to http://bugzilla.kernel.org.
diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index d6b45a9..3975758 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -560,7 +560,7 @@ NO!!!! No more huge patch bombs to linux-kernel@vger.kernel.org people!
   <http://marc.theaimsgroup.com/?l=linux-kernel&m=112112749912944&w=2>
 
 Kernel Documentation/CodingStyle:
-  <http://sosdg.org/~coywolf/lxr/source/Documentation/CodingStyle>
+  <http://users.sosdg.org/~qiyong/lxr/source/Documentation/CodingStyle>
 
 Linus Torvalds's mail on the canonical patch format:
   <http://lkml.org/lkml/2005/4/7/183>
-- 
1.5.3.rc5

