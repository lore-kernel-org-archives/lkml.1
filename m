Return-Path: <linux-kernel-owner+w=401wt.eu-S1765809AbYESWR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765809AbYESWR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765447AbYESWKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:10:41 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45245 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765129AbYESWKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:10:39 -0400
Date: Tue, 20 May 2008 01:08:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: shemminger@linux-foundation.org
Cc: bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] bridge: update URL
Message-ID: <20080519220834.GT17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the URL of the bridge homepage.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/networking/bridge.txt |    2 +-
 MAINTAINERS                         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

442926ef29170feab89570cbe478e8dff2946f6d diff --git a/Documentation/networking/bridge.txt b/Documentation/networking/bridge.txt
index bdae2db..bec69a8 100644
--- a/Documentation/networking/bridge.txt
+++ b/Documentation/networking/bridge.txt
@@ -1,6 +1,6 @@
 In order to use the Ethernet bridging functionality, you'll need the
 userspace tools. These programs and documentation are available
-at http://bridge.sourceforge.net.  The download page is
+at http://www.linux-foundation.org/en/Net:Bridge.  The download page is
 http://prdownloads.sourceforge.net/bridge.
 
 If you still have questions, don't hesitate to post to the mailing list 
diff --git a/MAINTAINERS b/MAINTAINERS
index bfbe353..52b7035 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1591,7 +1591,7 @@ ETHERNET BRIDGE
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
 L:	bridge@lists.linux-foundation.org
-W:	http://bridge.sourceforge.net/
+W:	http://www.linux-foundation.org/en/Net:Bridge
 S:	Maintained
 
 ETHERTEAM 16I DRIVER

