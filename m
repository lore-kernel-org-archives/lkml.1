Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbYBON1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbYBON1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933181AbYBON10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:27:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024AbYBON1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:27:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] MN10300: Define SO_MARK
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 15 Feb 2008 13:27:20 +0000
Message-ID: <20080215132720.22161.4092.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080215132715.22161.62836.stgit@warthog.procyon.org.uk>
References: <20080215132715.22161.62836.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define SO_MARK for MN10300.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-mn10300/socket.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/include/asm-mn10300/socket.h b/include/asm-mn10300/socket.h
index 99ca648..80af9c4 100644
--- a/include/asm-mn10300/socket.h
+++ b/include/asm-mn10300/socket.h
@@ -52,4 +52,6 @@
 #define SO_TIMESTAMPNS		35
 #define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
 
+#define SO_MARK			36
+
 #endif /* _ASM_SOCKET_H */

