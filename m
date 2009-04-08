Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbZDHRU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbZDHRU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZDHRUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:20:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:59369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZDHRUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:20:07 -0400
Subject: [PATCH] x86: cpu_debug remove execute permission
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 22:49:46 +0530
Message-Id: <1239211186.9037.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems by mistake these files got execute permissions so removing it.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 arch/x86/include/asm/cpu_debug.h
 mode change 100755 => 100644 arch/x86/kernel/cpu/cpu_debug.c

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
old mode 100755
new mode 100644
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
old mode 100755
new mode 100644
-- 
1.6.0.6



