Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbXDJOLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbXDJOLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXDJOLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:11:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41223 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbXDJOLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:11:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Update the FRV arch MAINTAINER record to get a hit on
	"grep -i frv"
To: torvalds@osdl.org, akpm@osdl.org, rpjday@mindspring.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 10 Apr 2007 15:10:45 +0100
Message-ID: <20070410141045.12804.53468.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Update the FRV arch MAINTAINER record to get a hit on "grep -i frv".  Whilst
FR-V is technically correct, it's normally thought of as FRV.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 829407f..ef84419 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1404,7 +1404,7 @@ M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained
 
-FUJITSU FR-V PORT
+FUJITSU FR-V (FRV) PORT
 P:	David Howells
 M:	dhowells@redhat.com
 S:	Maintained

