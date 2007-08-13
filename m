Return-Path: <linux-kernel-owner+w=401wt.eu-S945219AbXHMMLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945219AbXHMMLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967542AbXHMGkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2500 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763465AbXHMGkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:13 -0400
Date: Sun, 12 Aug 2007 23:39:56 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-hams@vger.kernel.org, jpr@f6fbb.org, akpm@linux-foundation.org
Subject: [PATCH] [549/2many] MAINTAINERS - YAM DRIVER FOR AX.25
Message-ID: <46bffcbc.ujCG+gItmFGoLOJI%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f932e7c..2773da9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5198,6 +5198,8 @@ P:	Jean-Paul Roubelat
 M:	jpr@f6fbb.org
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	drivers/net/hamradio/yam*
+F:	include/linux/yam.h
 
 YEALINK PHONE DRIVER
 P:	Henk Vergonet
