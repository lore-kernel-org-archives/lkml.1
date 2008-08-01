Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYHANP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYHANP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYHANPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:15:10 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45757 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750916AbYHANPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:15:09 -0400
Date: Fri, 1 Aug 2008 08:15:07 -0500
From: Jack Steiner <steiner@sgi.com>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] - Add maintainers for GRU, XPC, XPNET and XP
Message-ID: <20080801131507.GA109173@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAINTAINERS for GRU, XPNET, XPC and XP drivers.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/MAINTAINERS
===================================================================
--- linux.orig/MAINTAINERS	2008-07-16 17:48:07.000000000 -0500
+++ linux/MAINTAINERS	2008-08-01 08:06:03.000000000 -0500
@@ -3716,6 +3716,16 @@ L:	linux-visws-devel@lists.sf.net
 W:	http://linux-visws.sf.net
 S:	Maintained for 2.6.
 
+SGI GRU DRIVER
+P:	Jack Steiner
+M:	steiner@sgi.com
+S:	Maintained
+
+SGI XP/XPC/XPNET DRIVER
+P:	Dean Nelson
+M:	dcn@sgi.com
+S:	Maintained
+
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
 P:	Vincent Sanders
