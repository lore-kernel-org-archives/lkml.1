Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXGQH6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXGQH6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933220AbXGQH5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:57:51 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:41248 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933032AbXGQH5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:57:50 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: trivial@kernel.org
Subject: [PATCH][Doc] Typo: fro -> from
Date: Tue, 17 Jul 2007 09:57:48 +0200
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707170957.49366.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit 11a9dc32fadc7fe6722dc62ce84f0e483eb85368
tree bc08486dd569753148b5e09d000866cec4d971d7
parent a3036bca04b4e27427e01ed74fb93b8600595bce
author Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 17 Jul 2007 09:54:47 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 17 Jul 2007 09:54:47 +0200

 Documentation/console/console.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/console/console.txt b/Documentation/console/console.txt
index d3e1744..877a1b2 100644
--- a/Documentation/console/console.txt
+++ b/Documentation/console/console.txt
@@ -29,7 +29,7 @@ In newer kernels, the following are also available:
 
 If sysfs is enabled, the contents of /sys/class/vtconsole can be
 examined. This shows the console backends currently registered by the
-system which are named vtcon<n> where <n> is an integer fro 0 to 15. Thus:
+system which are named vtcon<n> where <n> is an integer from 0 to 15. Thus:
 
        ls /sys/class/vtconsole
        .  ..  vtcon0  vtcon1
