Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYKBOvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYKBOvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 09:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYKBOv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 09:51:29 -0500
Received: from havoc.gtf.org ([69.61.125.42]:60764 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbYKBOv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 09:51:28 -0500
Date: Sun, 2 Nov 2008 09:51:27 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [microPATCH] linux/string.h: fix comment typo
Message-ID: <20081102145127.GA19583@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


s/user/used/

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/include/linux/string.h b/include/linux/string.h
index 810d80d..d18fc19 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_STRING_H_
 #define _LINUX_STRING_H_
 
-/* We don't want strings.h stuff being user by user stuff by accident */
+/* We don't want strings.h stuff being used by user stuff by accident */
 
 #ifndef __KERNEL__
 #include <string.h>
