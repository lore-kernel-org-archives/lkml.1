Return-Path: <linux-kernel-owner+w=401wt.eu-S1765428AbXJOQdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765428AbXJOQdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760534AbXJOQdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:33:12 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:58415 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761068AbXJOQdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:33:10 -0400
Message-id: <31241866986722576@pripojeni.net>
In-reply-to: <3012721321185026886@pripojeni.net>
Subject: [PATCH 2/3] Misc: phantom, add comment about openhaptics
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 15 Oct 2007 12:33:10 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

phantom, add comment about openhaptics

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 931e139b87d4fdb9fcae6a39cc0a157ff2fc07e1
tree f0f98cff767ed04a2289a5c8ebbcad0d5757b23b
parent 7e792ef384190b517f2fb27cd0237fa30dbe0775
author Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:53:06 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 15 Oct 2007 15:53:06 +0200

 drivers/misc/phantom.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 6e61a79..bc532ac 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -9,6 +9,7 @@
  *  You need an userspace library to cooperate with this driver. It (and other
  *  info) may be obtained here:
  *  http://www.fi.muni.cz/~xslaby/phantom.html
+ *  or alternatively, you might use OpenHaptics provided by Sensable.
  */
 
 #include <linux/kernel.h>
