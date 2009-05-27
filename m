Return-Path: <linux-kernel-owner+w=401wt.eu-S933654AbZE0SY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbZE0SY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933409AbZE0SWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:22:19 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2937 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763321AbZE0SWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:22:18 -0400
Subject: [PATCH] MAINTAINERS: Add file patterns to TTY LAYER
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 11:22:18 -0700
Message-Id: <1243448538.27337.34.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0426b39..c970c56 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5558,6 +5558,11 @@ TTY LAYER
 P:	Alan Cox
 M:	alan@lxorguk.ukuu.org.uk
 S:	Maintained
+F:	drivers/char/tty_*
+F:	drivers/serial/serial_core.c
+F:	linux/serial_core.h
+F:	linux/serial.h
+F:	linux/tty.h
 
 TULIP NETWORK DRIVERS
 P:	Grant Grundler



