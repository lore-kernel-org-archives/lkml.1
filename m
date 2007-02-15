Return-Path: <linux-kernel-owner+w=401wt.eu-S964853AbXBOCQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853AbXBOCQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964856AbXBOCQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:16:08 -0500
Received: from imf19aec.mail.bellsouth.net ([205.152.59.67]:49828 "EHLO
	imf19aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964855AbXBOCQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:16:06 -0500
Date: Wed, 14 Feb 2007 20:16:00 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: [PATCH 4/6] atl1: remove unused define
Message-ID: <20070215021600.GE9753@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2007-01-26)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Remove unused define from atl1_main.c.

Signed-off-by: Chris Snook <csnook@redhat.com>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---

 drivers/net/atl1/atl1_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index 6655640..abce97e 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -82,7 +82,6 @@
 
 #include "atl1.h"
 
-#define RUN_REALTIME 0
 #define DRIVER_VERSION "2.0.6"
 
 char atl1_driver_name[] = "atl1";
