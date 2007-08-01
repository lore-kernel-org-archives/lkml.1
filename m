Return-Path: <linux-kernel-owner+w=401wt.eu-S933466AbXHAPEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466AbXHAPEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933756AbXHAPEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:04:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:23133 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbXHAPER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=NuESmLlw1x8sp/GuP1h2XAKLobNd5zV2bTK43cRIqPCU3BOwwgRMhMwI8JwwLn1XvLSHNHuS+t4QFkC7mnYCdkJgwsg2gudyTNlRcqh7tRdGPY7ZRluuVIoVTSl2V8zdrKpkDxf81/2g/yJnSj5ceZxf7TE/BoBTmf7E1ANIul4=
Message-ID: <46B0A0D4.4000402@googlemail.com>
Date: Wed, 01 Aug 2007 17:03:48 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Wolfgang Scherr <scherr@net4you.at>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Coding style fix drivers/media/video/zr36050.c
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

--- linux-mm-clean/drivers/media/video/zr36050.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/media/video/zr36050.c	2007-08-01 17:01:02.000000000 +0200
@@ -38,14 +38,14 @@
    #include<linux/videodev.h> */
 
 /* I/O commands, error codes */
-#include<asm/io.h>
+#include <asm/io.h>
 //#include<errno.h>
 
 /* headerfile of this module */
-#include"zr36050.h"
+#include "zr36050.h"
 
 /* codec io API */
-#include"videocodec.h"
+#include "videocodec.h"
 
 /* it doesn't make sense to have more than 20 or so,
   just to prevent some unwanted loops */
