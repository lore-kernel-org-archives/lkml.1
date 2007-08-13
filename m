Return-Path: <linux-kernel-owner+w=401wt.eu-S970874AbXHMJA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970874AbXHMJA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966908AbXHMGbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:11 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4921 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966727AbXHMGbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:08 -0400
Date: Sun, 12 Aug 2007 23:30:48 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       akpm@linux-foundation.org
Subject: [PATCH] [280/2many] MAINTAINERS - KERNEL VIRTUAL MACHINE (KVM)
Message-ID: <46bffa98.4PoqgUZtJrlJyHQh%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6e955c9..d9a53d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2684,6 +2684,8 @@ M:	avi@qumranet.com
 L:	kvm-devel@lists.sourceforge.net
 W:	kvm.sourceforge.net
 S:	Supported
+F:	drivers/kvm/
+F:	include/linux/kvm*
 
 KEXEC
 P:	Eric Biederman
