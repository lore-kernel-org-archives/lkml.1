Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbZHCWlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbZHCWlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZHCWlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:41:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:33393 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753052AbZHCWlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:41:14 -0400
X-Authenticated: #9008106
X-Provags-ID: V01U2FsdGVkX19dP5c1vPddC2HQ0or6KCSMpLva+3pucIRtNtu9ea
	RBd7JsEYfOABHo
Date: Tue, 4 Aug 2009 00:41:11 +0200
From: Michael Brunner <mibru@gmx.de>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] SubmittingPatches: Fix reference to renumbered step
Message-ID: <20090804004111.022dc119@mail.gmx.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a reference to step "Select e-mail destination." which
has been renumbered from 4) to 5) in linux-2.6.22.

Signed-off-by: Michael Brunner <mibru@gmx.de>

---

 Documentation/SubmittingPatches |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 5c555a8..b7f9d3b 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -183,7 +183,7 @@ the MAN-PAGES maintainer (as listed in the MAINTAINERS file)
 a man-pages patch, or at least a notification of the change,
 so that some information makes its way into the manual pages.
 
-Even if the maintainer did not respond in step #4, make sure to ALWAYS
+Even if the maintainer did not respond in step #5, make sure to ALWAYS
 copy the maintainer when you change their code.
 
 For small patches you may want to CC the Trivial Patch Monkey
