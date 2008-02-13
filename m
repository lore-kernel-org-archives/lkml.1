Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbYBMWbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbYBMWbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbYBMWbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:31:04 -0500
Received: from styx.suse.cz ([82.119.242.94]:56800 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753081AbYBMWbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:31:01 -0500
Date: Wed, 13 Feb 2008 23:31:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: casey@schaufler-ca.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SMACK: add maintainers entry
Message-ID: <Pine.LNX.4.64.0802132329300.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey,

what do you think about this one? :) We really should have entry for smack 
there. Thanks.


From: Jiri Kosina <jkosina@suse.cz>

SMACK: add maintainers entry

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6680ec4..0461c3c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1888,6 +1888,13 @@ W:	http://www.ia64-linux.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 S:	Maintained
 
+SMACK (Simplified Mandatory Access Control Kernel)
+P:	Casey Schaufler
+M:	casey@schaufler-ca.com
+L:	linux-kernel@vger.kernel.org
+W:	http://schaufler-ca.com/
+S:	Maintained
+
 SN-IA64 (Itanium) SUB-PLATFORM
 P:	Jes Sorensen
 M:	jes@sgi.com
