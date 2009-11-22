Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZKVIUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZKVIUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 03:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZKVIUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 03:20:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:49210 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZKVIUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 03:20:35 -0500
Subject: [PATCH] net: Fix missing kernel-doc notation
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>, David Miller <davem@davemloft.net>,
       Eric Dumazet <eric.dumazet@gmail.com>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:49:06 +0530
Message-Id: <1258877946.4495.52.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following htmldocs warning:

  Warning(net/core/dev.c:5378): bad line:

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/core/dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9977288..bd32d7a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5375,7 +5375,7 @@ EXPORT_SYMBOL(synchronize_net);
  *	unregister_netdevice_queue - remove device from the kernel
  *	@dev: device
  *	@head: list
-
+ *
  *	This function shuts down a device interface and removes it
  *	from the kernel tables.
  *	If head not NULL, device is queued to be unregistered later.
-- 
1.6.5.3


