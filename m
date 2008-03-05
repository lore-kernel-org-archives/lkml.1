Return-Path: <linux-kernel-owner+w=401wt.eu-S935774AbYCEAw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935774AbYCEAw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933616AbYCEAtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:49:21 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2508 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761325AbYCEAtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:49:19 -0500
Subject: [PATCH] arch/x86/kernel/cpu/feature_names.c - use angle brackets
	for include
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 16:47:00 -0800
Message-Id: <1204678020.5180.92.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.1mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

arch/x86/kernel/cpu/feature_names.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/feature_names.c b/arch/x86/kernel/cpu/feature_names.c
index ee975ac..e43ad4a 100644
--- a/arch/x86/kernel/cpu/feature_names.c
+++ b/arch/x86/kernel/cpu/feature_names.c
@@ -4,7 +4,7 @@
  * This file must not contain any executable code.
  */
 
-#include "asm/cpufeature.h"
+#include <asm/cpufeature.h>
 
 /*
  * These flag bits must match the definitions in <asm/cpufeature.h>.


