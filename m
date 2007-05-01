Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbXEACLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbXEACLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 22:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbXEACLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 22:11:40 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:53461 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754467AbXEACLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 22:11:38 -0400
Date: Tue, 1 May 2007 11:11:36 +0900
From: Simon Horman <horms@verge.net.au>
To: kexec@lists.infradead.org, fastboot@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Haren Myneni <hbabu@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Update the list information for kexec and kdump
Message-ID: <20070501021135.GC18364@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new list for kexec/kdump discussion.

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>

--- 
Update: osdl.org -> linux-foundation.org

Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS	2007-04-23 17:34:30.000000000 +0900
+++ linux-2.6/MAINTAINERS	2007-04-23 17:34:47.000000000 +0900
@@ -1951,7 +1951,7 @@ P:	Vivek Goyal
 M:	vgoyal@in.ibm.com
 P:	Haren Myneni
 M:	hbabu@us.ibm.com
-L:	fastboot@lists.linux-foundation.org
+L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
@@ -2001,7 +2001,7 @@ P:	Eric Biederman
 M:	ebiederm@xmission.com
 W:	http://www.xmission.com/~ebiederm/files/kexec/
 L:	linux-kernel@vger.kernel.org
-L:	fastboot@lists.linux-foundation.org
+L:	kexec@lists.infradead.org
 S:	Maintained
 
 KPROBES
