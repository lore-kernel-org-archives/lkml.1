Return-Path: <linux-kernel-owner+w=401wt.eu-S933944AbXHAPBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944AbXHAPBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933689AbXHAPAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:00:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:20079 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472AbXHAPAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=J6QqIDMGT4244eqJo+4YH595o28yHAQqR6oM6+M53VqBHht60ybdtfT4gZIvxeJq04Bf0vBktB8HHUdHWxlBvMhNyP0XGgk48yXyeyomNepVWmHCjIjSmGyYeUEaK+dhx0IUXbISs5q9JqEuM6LWKIRJfu0nrbYAcJ2To0xALK4=
Message-ID: <46B09FFF.1040308@googlemail.com>
Date: Wed, 01 Aug 2007 17:00:15 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Coding style fix drivers/media/video/zr36060.c
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

--- linux-mm-clean/drivers/media/video/zr36060.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/media/video/zr36060.c	2007-08-01 16:57:48.000000000 +0200
@@ -38,14 +38,14 @@
    #include<linux/videodev.h> */
 
 /* I/O commands, error codes */
-#include<asm/io.h>
+#include <asm/io.h>
 //#include<errno.h>
 
 /* headerfile of this module */
-#include"zr36060.h"
+#include "zr36060.h"
 
 /* codec io API */
-#include"videocodec.h"
+#include "videocodec.h"
 
 /* it doesn't make sense to have more than 20 or so,
   just to prevent some unwanted loops */
