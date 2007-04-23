Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXDWIjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXDWIjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXDWIjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:39:43 -0400
Received: from koto.vergenet.net ([210.128.90.7]:34852 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbXDWIjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:39:42 -0400
Date: Mon, 23 Apr 2007 17:39:36 +0900
From: Simon Horman <horms@verge.net.au>
To: kexec@lists.infradead.org, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Haren Myneni <hbabu@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Update the list information for kexec and kdump
Message-ID: <20070423083936.GI4272@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update the list information for kexec and kdump

Signed-off-by: Simon Horman <horms@verge.net.au>

--- 
Is it too early for this change?


Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS	2007-04-23 17:34:30.000000000 +0900
+++ linux-2.6/MAINTAINERS	2007-04-23 17:34:47.000000000 +0900
@@ -1951,7 +1951,7 @@ P:	Vivek Goyal
 M:	vgoyal@in.ibm.com
 P:	Haren Myneni
 M:	hbabu@us.ibm.com
-L:	fastboot@lists.osdl.org
+L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
@@ -2001,7 +2001,7 @@ P:	Eric Biederman
 M:	ebiederm@xmission.com
 W:	http://www.xmission.com/~ebiederm/files/kexec/
 L:	linux-kernel@vger.kernel.org
-L:	fastboot@lists.osdl.org
+L:	kexec@lists.infradead.org
 S:	Maintained
 
 KPROBES
