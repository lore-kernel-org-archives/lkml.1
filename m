Return-Path: <linux-kernel-owner+w=401wt.eu-S933517AbXHAOzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517AbXHAOzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbXHAOzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:55:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:15664 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbXHAOz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ZgaXBYNRVDoCsurJZ0EVsoI1zeFVSrsQy5lhf2fAXrvVmUTSOpJy1G82k7NeZYoCNswlCLyBXOzuLaG2lIdq/bIFf7NNKUcAOb26XHQ+JNowDz+QSQe4sKm6zez1t2ej1O0BrYVMTTOefGJXewbEjKla+63jESKljkyIZwpCc+E=
Message-ID: <46B09EC4.2010704@googlemail.com>
Date: Wed, 01 Aug 2007 16:55:00 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>, parisc-linux@parisc-linux.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Coding style fix include/asm-parisc/compat_rt_sigframe.h
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Coding style fix

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-mm-clean/include/asm-parisc/compat_rt_sigframe.h	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/include/asm-parisc/compat_rt_sigframe.h	2007-08-01 16:51:57.000000000 +0200
@@ -1,6 +1,6 @@
-#include<linux/compat.h>
-#include<linux/compat_siginfo.h>
-#include<asm/compat_ucontext.h>
+#include <linux/compat.h>
+#include <linux/compat_siginfo.h>
+#include <asm/compat_ucontext.h>
 
 #ifndef _ASM_PARISC_COMPAT_RT_SIGFRAME_H
 #define _ASM_PARISC_COMPAT_RT_SIGFRAME_H
