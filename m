Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYE0QLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYE0QLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbYE0QK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:10:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:24076 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854AbYE0QK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=jEjXPIRjKNCLsC8tKGoGsv74NOr3zLiYehbgpQ3pSnV2dtI8sIbc4atPrYE3sI8feo6+O9homdbFpdvdczPAenCwjs47H0FTgJQ/ssv2wIn020uSPu05H/eQBCxcyU3jWifJPWRJ2OkFCuk0zofx1YksnhrixA3nhjrUGu5GtEE=
Date: Tue, 27 May 2008 18:10:51 +0200
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mn10300: fix typo in header guard
Message-ID: <20080527161051.GD7550@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 27 May 2008 17:29:47 +0200
Subject: [PATCH] mn10300: fix typo in header guard

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-mn10300/ipcbuf.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-mn10300/ipcbuf.h b/include/asm-mn10300/ipcbuf.h
index efbbef8..f6f63d4 100644
--- a/include/asm-mn10300/ipcbuf.h
+++ b/include/asm-mn10300/ipcbuf.h
@@ -1,4 +1,4 @@
-#ifndef _ASM_IPCBUF_H_
+#ifndef _ASM_IPCBUF_H
 #define _ASM_IPCBUF_H
 
 /*
-- 
1.5.4.1

