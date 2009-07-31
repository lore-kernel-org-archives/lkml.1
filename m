Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbZGaL7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbZGaL7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 07:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZGaL7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 07:59:30 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43668 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751367AbZGaL73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 07:59:29 -0400
Date: Fri, 31 Jul 2009 13:59:27 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Steven Rostedt <srostedt@redhat.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] spelling: trace - "interfer with"
Message-ID: <alpine.LRH.2.00.0907311358550.21349@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 kernel/trace/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 019f380..be97c3c 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -490,7 +490,7 @@ config RING_BUFFER_BENCHMARK
 	depends on RING_BUFFER
 	help
 	  This option creates a test to stress the ring buffer and bench mark it.
-	  It creates its own ring buffer such that it will not interfer with
+	  It creates its own ring buffer such that it will not interfere with
 	  any other users of the ring buffer (such as ftrace). It then creates
 	  a producer and consumer that will run for 10 seconds and sleep for
 	  10 seconds. Each interval it will print out the number of events
-- 
1.6.2.4

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
