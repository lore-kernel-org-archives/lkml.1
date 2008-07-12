Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYGLPrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYGLPrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 11:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYGLPrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 11:47:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbYGLPrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 11:47:45 -0400
Date: Sat, 12 Jul 2008 17:47:34 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: [PATCH] Corrected wrong kernel bugzilla FAQ URL in documentation.
Message-ID: <20080712174734.3ef1a038@psychotron.englab.brq.redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Just corrected kernel bugzilla FAQ URL. It was a death link.

Jirka

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
---
 Documentation/HOWTO |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 0291ade..619e8ca 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -377,7 +377,7 @@ Bug Reporting
 bugzilla.kernel.org is where the Linux kernel developers track kernel
 bugs.  Users are encouraged to report all bugs that they find in this
 tool.  For details on how to use the kernel bugzilla, please see:
-	http://test.kernel.org/bugzilla/faq.html
+	http://bugzilla.kernel.org/page.cgi?id=faq.html
 
 The file REPORTING-BUGS in the main kernel source directory has a good
 template for how to report a possible kernel bug, and details what kind
-- 
1.5.5.1

