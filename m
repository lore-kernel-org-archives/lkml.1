Return-Path: <linux-kernel-owner+w=401wt.eu-S1759112AbYC1Omv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbYC1Omv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbYC1Ofs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:35:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbYC1Oeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:34:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/45] AFS: Add a MAINTAINERS record for AFS [ver #35]
To: torvalds@osdl.org, akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       chuck.lever@oracle.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 28 Mar 2008 14:32:24 +0000
Message-ID: <20080328143224.3483.64880.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
References: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
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
index f1ed75c..38659ac 100644
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

