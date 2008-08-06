Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbYHFNbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbYHFNbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYHFNaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:30:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:34414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbYHFNaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:30:21 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
From: Karsten Keil <kkeil@suse.de>
Subject: [PATCH 2/3] Cosmetic fixes
Message-Id: <20080806133019.ACD7ABC11C@pingi.kke.suse.de>
Date: Wed,  6 Aug 2008 15:30:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

found by Randy Dunlap.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 Documentation/isdn/README.mISDN |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/isdn/README.mISDN b/Documentation/isdn/README.mISDN
index cd8bf92..5271e66 100644
--- a/Documentation/isdn/README.mISDN
+++ b/Documentation/isdn/README.mISDN
@@ -1,6 +1,6 @@
-mISDN is a new modular ISDN driver, in the long term it should replace
-the old I4L driver architecture for passiv ISDN cards.
-It was designed to allow a broad range of applications and interfaces
-but only have the basic function in kernel, the interface to the user
-space is based on sockets with a own address family AF_ISDN.
+mISDN is a new modular ISDN driver. In the long term, it should replace
+the old I4L driver architecture for passive ISDN cards.
 
+It was designed to allow a broad range of applications and interfaces
+but only have the basic function in kernel. The interface to the user
+space is based on sockets with its own address family AF_ISDN.
-- 
1.5.6.4

