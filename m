Return-Path: <linux-kernel-owner+w=401wt.eu-S935634AbYCEAu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935634AbYCEAu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933664AbYCEAsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:48:55 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2505 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S935422AbYCEAsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:48:53 -0500
Subject: [PATCH] include/asm-x86/mutex_32.h - Use angle brackets for include
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 16:46:27 -0800
Message-Id: <1204677987.5180.91.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.1mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

 include/asm-x86/mutex_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/mutex_32.h b/include/asm-x86/mutex_32.h
index bbeefb9..9a6b3da 100644
--- a/include/asm-x86/mutex_32.h
+++ b/include/asm-x86/mutex_32.h
@@ -9,7 +9,7 @@
 #ifndef _ASM_MUTEX_H
 #define _ASM_MUTEX_H
 
-#include "asm/alternative.h"
+#include <asm/alternative.h>
 
 /**
  *  __mutex_fastpath_lock - try to take the lock by moving the count


