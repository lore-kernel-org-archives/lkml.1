Return-Path: <linux-kernel-owner+w=401wt.eu-S933452AbXHAOvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbXHAOvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411AbXHAOuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:50:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:12017 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbXHAOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=UW2HlcikLWUKdCjZEn6PkB8cPxP5Aubn2/kTqq9sJR5Zx0B4w1Dn2LKmrULohaeNB53jBKAakk0Xxzrw+f5DJ+G55CKJW2C8wErR87QTGEJMg8h1E49GOetE7QA/3goubEo68o3UQnQDAJMITRgoJnP12QNvkd90lkzu+7o/GPE=
Message-ID: <46B09DA1.8090905@googlemail.com>
Date: Wed, 01 Aug 2007 16:50:09 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Bryan Wu <bryan.wu@analog.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Coding style fix include/asm-blackfin/errno.h
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

--- linux-mm-clean/include/asm-blackfin/errno.h	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/include/asm-blackfin/errno.h	2007-08-01 16:46:05.000000000 +0200
@@ -1,6 +1,6 @@
 #ifndef _BFIN_ERRNO_H
 #define _BFIN_ERRNO_H
 
-#include<asm-generic/errno.h>
+#include <asm-generic/errno.h>
 
 #endif				/* _BFIN_ERRNO_H */
