Return-Path: <linux-kernel-owner+w=401wt.eu-S970623AbXHMI4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970623AbXHMI4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966686AbXHMGa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4879 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966865AbXHMGa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:57 -0400
Date: Sun, 12 Aug 2007 23:30:15 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       acme@ghostprotocols.net
Subject: [PATCH] [265/2many] MAINTAINERS - IPX NETWORK LAYER
Message-ID: <46bffa77.3120F64/J9KoEIar%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c1a9131..b97c776 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2533,6 +2533,9 @@ P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	include/linux/ipx.h
+F:	include/net/ipx.h
+F:	net/ipx/
 
 IRDA SUBSYSTEM
 P:	Samuel Ortiz
