Return-Path: <linux-kernel-owner+w=401wt.eu-S1765277AbYD1Frs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765277AbYD1Frs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763309AbYD1Frc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:47:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49960 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763259AbYD1Fr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:47:29 -0400
Date: Sun, 27 Apr 2008 22:46:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Cc: mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] docbook: x86 bitops file renamed
Message-Id: <20080427224625.749c78cb.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Files merged/renamed, so fix docbook:

docproc: next-20080428/include/asm-x86/bitops_32.h: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-20080428.orig/Documentation/DocBook/kernel-api.tmpl
+++ next-20080428/Documentation/DocBook/kernel-api.tmpl
@@ -119,7 +119,7 @@ X!Ilib/string.c
 !Elib/string.c
      </sect1>
      <sect1><title>Bit Operations</title>
-!Iinclude/asm-x86/bitops_32.h
+!Iinclude/asm-x86/bitops.h
      </sect1>
   </chapter>
 
