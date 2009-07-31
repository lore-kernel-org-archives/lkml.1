Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZGaIrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZGaIrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZGaIrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:47:05 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:59410 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbZGaIrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:47:05 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907310846.n6V8kxlZ006767@mercury.physics.adelaide.edu.au>
Subject: [PATCH 4/4] fujitsu-laptop: increment driver version
To: linux-acpi@vger.kernel.org
Date: Fri, 31 Jul 2009 18:16:59 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org, bzolnier@gmail.com
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 4/4] fujitsu-laptop: increment driver version

Increment driver version to reflect the changes from this patch series.

Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

--- a/drivers/platform/x86/fujitsu-laptop.c	2009-07-31 17:14:26.075776718 +0930
+++ b/drivers/platform/x86/fujitsu-laptop.c	2009-07-31 17:18:42.707203000 +0930
@@ -70,7 +70,7 @@
 #include <linux/leds.h>
 #endif
 
-#define FUJITSU_DRIVER_VERSION "0.5.0"
+#define FUJITSU_DRIVER_VERSION "0.6.0"
 
 #define FUJITSU_LCD_N_LEVELS 8
 
