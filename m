Return-Path: <linux-kernel-owner+w=401wt.eu-S1763110AbYD3Ro5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763110AbYD3Ro5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbYD3Rot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:44:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40826 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbYD3Ros (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:44:48 -0400
Subject: [PATCH 1/1] Embedded Maintainer(s), linux-embedded@vger list
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <1209577322.25560.402.camel@pmac.infradead.org>
References: <1209577322.25560.402.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 18:44:43 +0100
Message-Id: <1209577483.25560.405.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Paul and myself, and the linux-embedded list, to MAINTAINERS.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index bca09ed..3650ed1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1550,6 +1550,14 @@ M:	raisch@de.ibm.com
 L:	general@lists.openfabrics.org
 S:	Supported
 
+EMBEDDED LINUX
+P:	Paul Gortmaker
+M:	paul.gortmaker@windriver.com
+P	David Woodhouse
+M:	dwmw2@infradead.org
+L:	linux-embedded@vger.kernel.org
+S:	Maintained
+
 EMULEX LPFC FC SCSI DRIVER
 P:	James Smart
 M:	james.smart@emulex.com

-- 
dwmw2

