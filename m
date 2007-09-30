Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbXI3W6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbXI3W6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbXI3W6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:58:16 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:6619 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbXI3W6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:58:15 -0400
Date: Sun, 30 Sep 2007 16:57:02 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 1/6] Add Xilinx SystemACE entry to maintainers
In-reply-to: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       axboe@kernel.dk
Message-id: <20070930225700.2476.2216.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

I'm the author of the SystemACE driver

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f80068..cb6323e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4179,6 +4179,13 @@ W:	http://oss.sgi.com/projects/xfs
 T:	git git://oss.sgi.com:8090/xfs/xfs-2.6.git
 S:	Supported
 
+XILINX SYSTEMACE DRIVER
+P:	Grant Likely
+M:	grant.likely@secretlab.ca
+W:	http://www.secretlab.ca/
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 XILINX UARTLITE SERIAL DRIVER
 P:	Peter Korsgaard
 M:	jacmet@sunsite.dk

