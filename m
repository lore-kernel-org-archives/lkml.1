Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZBDOWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZBDOWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbZBDOTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:19:39 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34105 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbZBDOTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:19:33 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 7/7] Integrity: IMA update maintainers
Date: Wed,  4 Feb 2009 09:07:03 -0500
Message-Id: <516b507215f31d3be83e9986c7b356deae4030d0.1233750617.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 6bd7d47..12fc280 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2175,6 +2175,11 @@ M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
 
+INTEGRITY MEASUREMENT ARCHITECTURE (IMA)
+P:	Mimi Zohar
+M:	zohar@us.ibm.com
+S:	Supported
+
 IMS TWINTURBO FRAMEBUFFER DRIVER
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Orphan
-- 
1.5.6.6

