Return-Path: <linux-kernel-owner+w=401wt.eu-S934549AbXHAPNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549AbXHAPNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932648AbXHAPNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:13:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:31304 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276AbXHAPNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:13:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=P/V2BGNZcd88ue9Q/VYFI1lkvZgIwsUod7hPPnvhOHQqK4UNTAsXt99s8USGZLdS7d+yBqb/f4nMK9/mah+Mh4DvYE/Eb/oFwlnhaZaJBWZQnF3YcQn2UqObxK8SkhttlUYyt0AIyq2675UJimokrkMeH+pb/P3XGhsY3mG7jFs=
Message-ID: <46B0A30A.8090500@googlemail.com>
Date: Wed, 01 Aug 2007 17:13:14 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Coding style fix drivers/scsi/aha1542.c
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

--- linux-mm-clean/drivers/scsi/aha1542.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/aha1542.c	2007-08-01 17:09:40.000000000 +0200
@@ -77,7 +77,7 @@ static void BAD_SG_DMA(Scsi_Cmnd * SCpnt
 	panic("Buffer at physical address > 16Mb used for aha1542");
 }
 
-#include<linux/stat.h>
+#include <linux/stat.h>
 
 #ifdef DEBUG
 #define DEB(x) x
