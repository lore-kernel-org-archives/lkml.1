Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYCYTEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYCYTEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYCYTER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:04:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYCYTEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:04:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] AFS: Add a MAINTAINERS record for AFS
To: torvalds@osdl.org, akpm@linux-foundation.org, svens@stackframe.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 25 Mar 2008 19:03:39 +0000
Message-ID: <20080325190339.29835.44441.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a MAINTAINERS record for AFS

Signed-off-by: David Howells <dhowells@redhat.com>
---

 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index 73883b8..41d226e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -163,6 +163,12 @@ M:	A2232@gmx.net
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
 
+AFS FILESYSTEM & AF_RXRPC SOCKET DOMAIN
+P:	David Howells
+M:	dhowells@redhat.com
+L:	linux-afs@lists.infradead.org
+S:	Supported
+
 AIO
 P:	Benjamin LaHaise
 M:	bcrl@kvack.org

