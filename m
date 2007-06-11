Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbXFKXJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbXFKXJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbXFKXIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:08:09 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:13378 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753953AbXFKXIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:08:06 -0400
Date: Mon, 11 Jun 2007 17:11:24 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 5/5] driver edac remove file edac_mc-h
Message-ID: <466dd69c.Oew76AFma61wlC2/%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:   Douglas Thompson <dougthompson@xmission.com>

Removed the no-longer-needed file edac_mc.h 

Signed-off-by:  Douglas Thompson <dougthompson@xmission.com>
---
 edac_mc.h |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/edac/edac_mc.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/edac_mc.h
+++ /dev/null
@@ -1,7 +0,0 @@
-
-/*
- * Older .h file for edac, until all drivers are modified
- *
- */
-
-#include "edac_core.h"
