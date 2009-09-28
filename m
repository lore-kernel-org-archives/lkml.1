Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZI1Q1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZI1Q1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZI1Q1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:27:46 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:20904 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZI1Q1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:27:46 -0400
Date: Mon, 28 Sep 2009 09:26:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] docs: update patch size in SubmittingPatches
Message-Id: <20090928092657.f739be0c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4AC0E3D6.00E2:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

This patch size comment is like so last millenium.
Update it to modern times.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/SubmittingPatches |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2632-rc1.orig/Documentation/SubmittingPatches
+++ lnx-2632-rc1/Documentation/SubmittingPatches
@@ -232,7 +232,7 @@ your e-mail client so that it sends your
 When sending patches to Linus, always follow step #7.
 
 Large changes are not appropriate for mailing lists, and some
-maintainers.  If your patch, uncompressed, exceeds 40 kB in size,
+maintainers.  If your patch, uncompressed, exceeds 300 kB in size,
 it is preferred that you store your patch on an Internet-accessible
 server, and provide instead a URL (link) pointing to your patch.
 
---
