Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab0BRLqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:46:19 -0500
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:24453 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374Ab0BRLqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:46:18 -0500
X-Greylist: delayed 780 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Feb 2010 06:46:17 EST
Subject: [PATCH] Orphan DECnet
From: Christine Caulfield <christine.caulfield@googlemail.com>
To: netdev@vger.kernel.org, torvalds@linux-foundation.org, swhiteho@redhat.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 11:33:13 +0000
Message-ID: <1266492793.412.1.camel@rhdesktop.chrissie.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=1ggfb5FlKZQUfF3vzm9UBYZ2uTfLsbs/8dSljwg5+mE= c=1 sm=0 a=mK_AVkanAAAA:8 a=FP58Ms26AAAA:8 a=2E4yy07RBI6BVMYWW14A:9 a=PgpAqoAcqb4D4dw_bPwNO64JOj8A:4 a=9xyTavCNlvEA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiya all

Due to lack of time, space, motivation, hardware and probably expertise,
I have reluctantly decided to orphan the DECnet code in the kernel.

Judging by the deafening silence on the linux-decnet mailing list I
suspect it's either not being used anyway, or the few people that are
using it are happy with their older kernels.

Chrissie


Signed-Off-By: Christine Caulfield <christine.caulfield@googlemail.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 412eff6..8ed3d0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1733,10 +1733,9 @@ F:	include/linux/tfrc.h
 F:	net/dccp/
 
 DECnet NETWORK LAYER
-M:	Christine Caulfield <christine.caulfield@googlemail.com>
 W:	http://linux-decnet.sourceforge.net
 L:	linux-decnet-user@lists.sourceforge.net
-S:	Maintained
+S:	Orphan
 F:	Documentation/networking/decnet.txt
 F:	net/decnet/
 


