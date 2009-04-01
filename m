Return-Path: <linux-kernel-owner+w=401wt.eu-S1765582AbZDAAVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765582AbZDAAVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765543AbZDAAUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:20:55 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46154 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765536AbZDAAUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:20:54 -0400
Subject: Add hvc_console to MAINTAINERS
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       roel.kluin@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1238544253.6522.14.camel@localhost>
References: <49BF956B.9030109@gmail.com>
	 <20090330133531.f5d99c09.akpm@linux-foundation.org>
	 <20090330205553.GA19278@yoda.jdub.homelinux.org>
	 <20090330141852.59baaeda.akpm@linux-foundation.org>
	 <20090331132944.GB2332@yoda.jdub.homelinux.org>
	 <1238543040.6522.10.camel@localhost>
	 <20090331235057.GB563@zod.rchland.ibm.com>
	 <1238544253.6522.14.camel@localhost>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 11:20:50 +1100
Message-Id: <1238545250.6522.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a MAINTAINERS entry for the hypervisor virtual console driver.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

How about this?

diff --git a/MAINTAINERS b/MAINTAINERS
index 1c2ca1d..854437a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1918,6 +1918,12 @@ L:	lm-sensors@lm-sensors.org
 W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps/
 S:	Maintained
 
+HYPERVISOR VIRTUAL CONSOLE DRIVER
+L:	linuxppc-dev@ozlabs.org
+L:	linux-kernel@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/char/hvc_*
+
 GSPCA FINEPIX SUBDRIVER
 P:	Frank Zago
 M:	frank@zago.net
-- 
1.6.1.2



