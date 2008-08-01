Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbYHAQBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbYHAQBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYHAQBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:01:32 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:25113 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYHAQBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:01:30 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] PNP: add Bjorn Helgaas as PNP co-maintainer
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Rene Herman <rene.herman@keyaccess.nl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 01 Aug 2008 10:01:12 -0600
Message-ID: <20080801160047.28518.51260.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update Adam's email address and add myself as PNP co-maintainer.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 MAINTAINERS |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index deedc0d..3ae0e33 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3314,7 +3314,9 @@ S:	Maintained
 
 PNP SUPPORT
 P:	Adam Belay
-M:	ambx1@neo.rr.com
+M:	abelay@mit.edu
+P:	Bjorn Helgaas
+M:	bjorn.helgaas@hp.com
 S:	Maintained
 
 PNXxxxx I2C DRIVER

