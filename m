Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbYECPgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbYECPgI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbYECPf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:35:56 -0400
Received: from outbound-mail-118.bluehost.com ([69.89.22.18]:40228 "HELO
	outbound-mail-118.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757324AbYECPf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:35:56 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] PCI list moved
Date: Sat, 3 May 2008 08:35:49 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805030835.49845.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many thanks to Martin for his years of hosting.  The pci list has moved to 
vger, along with what seems like the rest of the major Linux mailing lists.

Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index 93547d3..abe2787 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3130,7 +3130,7 @@ PCI SUBSYSTEM
 P:	Jesse Barnes
 M:	jbarnes@virtuousgeek.org
 L:	linux-kernel@vger.kernel.org
-L:	linux-pci@atrey.karlin.mff.cuni.cz
+L:	linux-pci@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
 
