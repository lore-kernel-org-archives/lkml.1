Return-Path: <linux-kernel-owner+w=401wt.eu-S943247AbXHMINJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943247AbXHMINJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966652AbXHMG2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:30 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4474 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965547AbXHMG2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:25 -0400
Date: Sun, 12 Aug 2007 23:28:04 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, akpm@linux-foundation.org
Subject: [PATCH] [202/2many] MAINTAINERS - FUJITSU FR-V (FRV) PORT
Message-ID: <46bff9f4.qKrF09RQKrXXwPpj%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e1d3ee3..203719a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1935,6 +1935,8 @@ FUJITSU FR-V (FRV) PORT
 P:	David Howells
 M:	dhowells@redhat.com
 S:	Maintained
+F:	arch/frv/
+F:	include/asm-frv/
 
 FUSE: FILESYSTEM IN USERSPACE
 P:	Miklos Szeredi
