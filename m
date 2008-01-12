Return-Path: <linux-kernel-owner+w=401wt.eu-S1763586AbYALLdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763586AbYALLdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762727AbYALLdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:33:24 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60450 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701AbYALLdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:33:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 12 Jan 2008 12:32:44 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire vs. ieee1394: clarify MAINTAINERS
To: linux-kernel@vger.kernel.org
cc: Ben Collins <ben.collins@ubuntu.com>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Message-ID: <tkrat.dda39df0ee7273d6@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintainers like to receive less mail, and submitters like to have to Cc
less recipients.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/MAINTAINERS
===================================================================
--- linux.orig/MAINTAINERS
+++ linux/MAINTAINERS
@@ -1571,7 +1571,7 @@ P:	Alexander Viro
 M:	viro@zeniv.linux.org.uk
 S:	Maintained
 
-FIREWIRE SUBSYSTEM
+FIREWIRE SUBSYSTEM (drivers/firewire, <linux/firewire*.h>)
 P:	Kristian Hoegsberg, Stefan Richter
 M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
@@ -1891,7 +1891,7 @@ L:	linux-ide@vger.kernel.org
 L:	linux-scsi@vger.kernel.org
 S:	Orphan
 
-IEEE 1394 SUBSYSTEM
+IEEE 1394 SUBSYSTEM (drivers/ieee1394)
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
 P:	Stefan Richter

-- 
Stefan Richter
-=====-==--- ---= -==--
http://arcgraph.de/sr/

