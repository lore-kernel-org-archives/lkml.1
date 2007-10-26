Return-Path: <linux-kernel-owner+w=401wt.eu-S1761480AbXJZMio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480AbXJZMio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbXJZMih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:38:37 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:54281 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbXJZMig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:38:36 -0400
Date: Fri, 26 Oct 2007 13:37:13 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@stusta.de>,
       Ian Molton <spyro@f2s.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] arm26: remove it again
Message-ID: <Pine.LNX.4.64.0710261333450.27848@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A tiny vestige of arm26 has appeared: remove it again.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.24-rc1/include/asm-arm26/irq_regs.h	2007-10-24 07:15:55.000000000 +0100
+++ linux/include/asm-arm26/irq_regs.h	1970-01-01 01:00:00.000000000 +0100
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
