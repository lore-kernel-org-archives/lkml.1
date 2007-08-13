Return-Path: <linux-kernel-owner+w=401wt.eu-S970518AbXHMMUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970518AbXHMMUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967908AbXHMGn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:43:56 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2545 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967895AbXHMGnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:43:55 -0400
Date: Sun, 12 Aug 2007 23:30:08 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jjciarla@raiz.uncu.edu.ar, akpm@linux-foundation.org
Subject: [PATCH] [262/2many] MAINTAINERS - IP MASQUERADING:
Message-ID: <46bffa70.RZBYyqSF1ZNzPpgZ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 207331c..629b64c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2508,6 +2508,7 @@ IP MASQUERADING:
 P:	Juanjo Ciarlante
 M:	jjciarla@raiz.uncu.edu.ar
 S:	Maintained
+F:	net/ipv4/netfilter/ipt_MASQUERADE.c
 
 IPATH DRIVER:
 P:	Arthur Jones
