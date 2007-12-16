Return-Path: <linux-kernel-owner+w=401wt.eu-S1764270AbXLPC2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764270AbXLPC2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 21:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXLPC1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 21:27:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:59813 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbXLPC1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 21:27:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=svUhzim/rWdbeY+95xQk1ulZNDpHHOhBacMDl22kYOvyISpl5VoGaG42pCzF9mpRL72xAfpr40nHYUG6biIc5zE0jFv1S3EbIW76BnnpcPabqgAbsCkoka/Zx/nzMxsX46e3+6/XDO3/5VECjJKxxGlj9a6Ry6Qn1rrkUYQ+zys=
Date: Sun, 16 Dec 2007 03:29:29 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH RESEND] asm-*/compat.h: fix typo in comment
Message-ID: <20071216022925.GK26986@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

comverted -> converted

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 include/asm-ia64/compat.h    |    2 +-
 include/asm-mips/compat.h    |    2 +-
 include/asm-parisc/compat.h  |    2 +-
 include/asm-powerpc/compat.h |    2 +-
 include/asm-s390/compat.h    |    2 +-
 include/asm-sparc64/compat.h |    2 +-
 include/asm-x86/compat.h     |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/asm-ia64/compat.h b/include/asm-ia64/compat.h
index 0f6e526..dfcf75b 100644
--- a/include/asm-ia64/compat.h
+++ b/include/asm-ia64/compat.h
@@ -181,7 +181,7 @@ struct compat_shmid64_ds {
 /*
  * A pointer passed in from user mode. This should not be used for syscall parameters,
  * just declare them as pointers because the syscall entry code will have appropriately
- * comverted them already.
+ * converted them already.
  */
 typedef	u32		compat_uptr_t;

diff --git a/include/asm-mips/compat.h b/include/asm-mips/compat.h
index 568c76c..ac5d541 100644
--- a/include/asm-mips/compat.h
+++ b/include/asm-mips/compat.h
@@ -128,7 +128,7 @@ typedef u32		compat_sigset_word;
  * A pointer passed in from user mode. This should not
  * be used for syscall parameters, just declare them
  * as pointers because the syscall entry code will have
- * appropriately comverted them already.
+ * appropriately converted them already.
  */
 typedef u32		compat_uptr_t;

diff --git a/include/asm-parisc/compat.h b/include/asm-parisc/compat.h
index 5a85d1b..7f32611 100644
--- a/include/asm-parisc/compat.h
+++ b/include/asm-parisc/compat.h
@@ -132,7 +132,7 @@ typedef u32		compat_sigset_word;
  * A pointer passed in from user mode. This should not
  * be used for syscall parameters, just declare them
  * as pointers because the syscall entry code will have
- * appropriately comverted them already.
+ * appropriately converted them already.
  */
 typedef	u32		compat_uptr_t;

diff --git a/include/asm-powerpc/compat.h b/include/asm-powerpc/compat.h
index 64ab1dd..d811a8c 100644
--- a/include/asm-powerpc/compat.h
+++ b/include/asm-powerpc/compat.h
@@ -119,7 +119,7 @@ typedef u32		compat_sigset_word;
  * A pointer passed in from user mode. This should not
  * be used for syscall parameters, just declare them
  * as pointers because the syscall entry code will have
- * appropriately comverted them already.
+ * appropriately converted them already.
  */
 typedef	u32		compat_uptr_t;

diff --git a/include/asm-s390/compat.h b/include/asm-s390/compat.h
index 7f4ad62..de065b3 100644
--- a/include/asm-s390/compat.h
+++ b/include/asm-s390/compat.h
@@ -149,7 +149,7 @@ typedef u32		compat_sigset_word;
  * A pointer passed in from user mode. This should not
  * be used for syscall parameters, just declare them
  * as pointers because the syscall entry code will have
- * appropriately comverted them already.
+ * appropriately converted them already.
  */
 typedef	u32		compat_uptr_t;

diff --git a/include/asm-sparc64/compat.h b/include/asm-sparc64/compat.h
index 01fe668..f260b58 100644
--- a/include/asm-sparc64/compat.h
+++ b/include/asm-sparc64/compat.h
@@ -152,7 +152,7 @@ typedef u32		compat_sigset_word;
  * A pointer passed in from user mode. This should not
  * be used for syscall parameters, just declare them
  * as pointers because the syscall entry code will have
- * appropriately comverted them already.
+ * appropriately converted them already.
  */
 typedef	u32		compat_uptr_t;

diff --git a/include/asm-x86/compat.h b/include/asm-x86/compat.h
index 66ba798..0e18cb5 100644
--- a/include/asm-x86/compat.h
+++ b/include/asm-x86/compat.h
@@ -190,7 +190,7 @@ typedef struct user_regs_struct32 compat_elf_gregset_t;
  * A pointer passed in from user mode. This should not
  * be used for syscall parameters, just declare them
  * as pointers because the syscall entry code will have
- * appropriately comverted them already.
+ * appropriately converted them already.
  */
 typedef	u32		compat_uptr_t;

--
1.5.3.4

