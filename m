Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZFKRjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZFKRjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZFKRiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:38:54 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3895 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZFKRix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:38:53 -0400
Subject: [PATCH] MAINTAINERS: Update 8250 section, give Alan Cox a name
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 10:38:54 -0700
Message-Id: <1244741934.30185.4.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 84285b5..9f755fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -157,9 +157,10 @@ S:	Maintained
 F:	drivers/net/r8169.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
+P:	Alan Cox
+M:	alan@lxorguk.ukuu.org.uk
 L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
-M:	alan@lxorguk.ukuu.org.uk
 S:	Odd Fixes
 F:	drivers/serial/8250*
 F:	include/linux/serial_8250.h


