Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYJGJyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYJGJyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYJGJyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:54:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33803 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbYJGJyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:54:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: MEI are renaming themselves to Panasonic
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2008 10:54:30 +0100
Message-ID: <20081007095429.27008.27795.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MEI are renaming themselves to Panasonic, so update the MAINTAINERS record for
the MN10300 arch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index 3596d17..c4164c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2756,7 +2756,7 @@ L:	linux-mm@kvack.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-MEI MN10300/AM33 PORT
+PANASONIC MN10300/AM33 PORT
 P:	David Howells
 M:	dhowells@redhat.com
 P:	Koichi Yasutake

