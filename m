Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbZGMQCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbZGMQCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbZGMQCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:02:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35340 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbZGMQCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:02:31 -0400
Subject: [PATCH] update JFS entry in MAINTAINERS
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 11:02:24 -0500
Message-Id: <1247500944.22887.5.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JFS hasn't really been supported for a while.  It's still maintained,
but saying it's supported is a stretch.  Updating my preferred email
address as well.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9d1601e..18c3f0c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3287,11 +3287,11 @@ F:	include/linux/ivtv*
 
 JFS FILESYSTEM
 P:	Dave Kleikamp
-M:	shaggy@austin.ibm.com
+M:	shaggy@linux.vnet.ibm.com
 L:	jfs-discussion@lists.sourceforge.net
 W:	http://jfs.sourceforge.net/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
-S:	Supported
+S:	Maintained
 F:	Documentation/filesystems/jfs.txt
 F:	fs/jfs/
 

-- 
David Kleikamp
IBM Linux Technology Center

