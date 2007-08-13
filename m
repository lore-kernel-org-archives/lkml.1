Return-Path: <linux-kernel-owner+w=401wt.eu-S934265AbXHMKhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbXHMKhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967289AbXHMGfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:55 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1757 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967272AbXHMGfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:41 -0400
Date: Sun, 12 Aug 2007 23:35:26 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jim.cromie@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] [424/2many] MAINTAINERS - SCx200 GPIO DRIVER
Message-ID: <46bffbae.pAMRu5GRJ6t5ZISE%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c4f7cff..aa43ddf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4036,6 +4036,8 @@ SCx200 GPIO DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Maintained
+F:	drivers/char/scx200_gpio.c
+F:	include/linux/scx200_gpio.h
 
 SCx200 HRT CLOCKSOURCE DRIVER
 P:	Jim Cromie
