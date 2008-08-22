Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYHVRB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYHVRB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYHVRBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:01:50 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:48626 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYHVRBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:01:49 -0400
Message-ID: <48AEF0EC.3080709@euromail.se>
Date: Fri, 22 Aug 2008 19:01:32 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: torvalds@linux-foundation.org, linux-input@vger.kernel.org,
       trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Adding a maintainer for the BCM5974 multitouch driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.33.80
X-Scan-Result: No virus found in message 1KWa1B-0006sq-3m.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KWa1B-0006sq-3m 18fdc587e913d2d79f8f5b24cf16fbf4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 28c69aa..74e3381 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -419,6 +419,12 @@ L:	linux-laptop@vger.kernel.org
 W:	http://www.canb.auug.org.au/~sfr/
 S:	Supported

+APPLE BCM5974 MULTITOUCH DRIVER
+P:	Henrik Rydberg
+M:	rydberg@euromail.se
+L:	linux-input@vger.kernel.org
+S:	Maintained
+
 APPLE SMC DRIVER
 P:	Nicolas Boichat
 M:	nicolas@boichat.ch
-- 
1.5.4.3

