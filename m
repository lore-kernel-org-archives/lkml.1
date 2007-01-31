Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbXAaKRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbXAaKRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940AbXAaKRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:17:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:4932 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938AbXAaKRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:17:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RsHBZyFXmrTcGYK1I7oflXrnCDQzqlL7hbLaRclW6Mi13X/bwpzEUDEpHqk97dv4iPDCLdqH5yDaIU+GjZcwY/TxW2NsQtWHys19hOzC8hLXkENJmDwfjfC7QvCzq4zT1Mhmg8thOzrUrH4u2223fSSrCBtUJn14ha6GM291KoU=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH][Trivial] Remove duplicate listing of Cris arch from README
Date: Wed, 31 Jan 2007 11:16:59 +0100
User-Agent: KMail/1.9.6
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       Trivial Patch Monkey <trivial@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311116.59262.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Mikael Pettersson pointed out to me that a recent patch of mine (commit
620034c84d1d939717bdfbe02c51a3fee43541c3), that made some corrections to the
README file, accidentally listed the Cris architecture twice.  Whoops.

This removes the duplicate. 
Patch against current git tree.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 README |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README b/README
index 46a66c6..159912c 100644
--- a/README
+++ b/README
@@ -24,7 +24,7 @@ ON WHAT HARDWARE DOES IT RUN?
   today Linux also runs on (at least) the Compaq Alpha AXP, Sun SPARC and
   UltraSPARC, Motorola 68000, PowerPC, PowerPC64, ARM, Hitachi SuperH, Cell,
   IBM S/390, MIPS, HP PA-RISC, Intel IA-64, DEC VAX, AMD x86-64, AXIS CRIS,
-  Cris, Xtensa, AVR32 and Renesas M32R architectures.
+  Xtensa, AVR32 and Renesas M32R architectures.
 
   Linux is easily portable to most general-purpose 32- or 64-bit architectures
   as long as they have a paged memory management unit (PMMU) and a port of the



