Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbYJMJ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbYJMJ50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762444AbYJMJmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:42:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33244 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762427AbYJMJmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:42:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: MEI are renaming themselves to Panasonic [ver #2]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:42:44 +0100
Message-ID: <20081013094244.26826.85060.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MEI are renaming themselves to Panasonic, so update the MAINTAINERS record for
the MN10300 arch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 MAINTAINERS |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index 6ba3ee8..74b8082 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2797,15 +2797,6 @@ L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
 
-MEI MN10300/AM33 PORT
-P:	David Howells
-M:	dhowells@redhat.com
-P:	Koichi Yasutake
-M:	yasutake.koichi@jp.panasonic.com
-L:	linux-am33-list@redhat.com (moderated for non-subscribers)
-W:	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
-S:	Maintained
-
 MICROTEK X6 SCANNER
 P:	Oliver Neukum
 M:	oliver@neukum.name
@@ -3170,6 +3161,15 @@ M:	olof@lixom.net
 L:	i2c@lm-sensors.org
 S:	Maintained
 
+PANASONIC MN10300/AM33 PORT
+P:	David Howells
+M:	dhowells@redhat.com
+P:	Koichi Yasutake
+M:	yasutake.koichi@jp.panasonic.com
+L:	linux-am33-list@redhat.com (moderated for non-subscribers)
+W:	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
+S:	Maintained
+
 PARALLEL PORT SUPPORT
 L:	linux-parport@lists.infradead.org (subscribers-only)
 S:	Orphan

