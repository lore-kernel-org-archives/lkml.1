Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbXHMJoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbXHMJoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967097AbXHMGdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:22 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1323 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965547AbXHMGdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:17 -0400
Date: Sun, 12 Aug 2007 23:31:20 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, acme@ghostprotocols.net
Subject: [PATCH] [297/2many] MAINTAINERS - LLC (802.2)
Message-ID: <46bffab8.U3F1zd1yRuy6mzkF%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6fdca8b..6d10932 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2843,6 +2843,9 @@ LLC (802.2)
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 S:	Maintained
+F:	include/linux/llc.h
+F:	include/net/llc*
+F:	net/llc/
 
 LINUX FOR 64BIT POWERPC
 P:	Paul Mackerras
