Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYBKJuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYBKJuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYBKJuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:50:21 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:17343 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYBKJuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:50:18 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111050.372086035@suse.de>
In-Reply-To: <200802111050.372086035@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/8] CPA: Remove my copyright notice
Message-Id: <20080211095016.633E01B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:50:16 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:43:55.0235 (UTC) FILETIME=[9E071B30:01C86C92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not much left from the original code and I don't want my name 
on it because there is code in there I disagree with.

I don't think any of the Ben inspired code is left in there
either, but I left his name in for now.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -1,5 +1,4 @@
 /*
- * Copyright 2002 Andi Kleen, SuSE Labs.
  * Thanks to Ben LaHaise for precious feedback.
  */
 #include <linux/highmem.h>
