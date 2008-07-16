Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbYGPAYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbYGPAYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758676AbYGPAXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:23:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656AbYGPAXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=NiQ/ZNKS0uvAM+9R7WXMb5LEDwfubU0cukvJy0JpVU5opG8qYVe7TU8rpbBEUX7zNn
         /FDbPT5VPitfOmBd3xOUxUBk3dypSBrFnT0KJDP46OkS6+d7l8MmDidHu4gQbQ1yJn0Z
         fdffY3kwrm9QytkEmKRAAJIoMXMBuNjj+j6A8=
Date: Wed, 16 Jul 2008 02:23:18 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/13] kmemcheck: add Vegard and Pekka to MAINTAINERS
Message-ID: <20080716002318.GG12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 17dae523b76600d6eacc56781cda695472254507 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Mon, 28 Apr 2008 22:47:29 +0300
Subject: [PATCH 06/13] kmemcheck: add Vegard and Pekka to MAINTAINERS

Acked-by: Vegard Nossum <vegardno@ifi.uio.no>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 56a2f67..6f5b155 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2425,6 +2425,14 @@ M:	jason.wessel@windriver.com
 L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
 
+KMEMCHECK
+P:	Vegard Nossum
+M:	vegardno@ifi.uio.no
+P	Pekka Enberg
+M:	penberg@cs.helsinki.fi
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 KPROBES
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com
-- 
1.5.5.1

