Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYGWOpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYGWOpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 10:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYGWOpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 10:45:03 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:42025 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbYGWOpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=wGIHy5APg8wiRjk+g7OM4dnYgUTiy0XfV9K8tHU0RacJIm2lMUMjCpxWGFfv5GpcOi
         TLQ6mhHqjxGpouhf5jeJg8GWpiT267ghaC5q/Qk2AM5zJPabORBa/pTd1l33CZRPBegY
         DJyCYlr642alwXrBDb57S2EzVKqdFlysNTbeM=
Date: Wed, 23 Jul 2008 22:45:01 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: arch/x86/kernel/genx2apic_uv_x.c: Removed duplicated include
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080723215912.9422.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="GB2312"
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6NEjofq003869

Removed duplicated include file <linux/kernel.h> in 
arch/x86/kernel/genx2apic_uv_x.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 3c39293..6b998ce 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -12,7 +12,6 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/string.h>
-#include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/sched.h>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
