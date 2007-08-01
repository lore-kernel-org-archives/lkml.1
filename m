Return-Path: <linux-kernel-owner+w=401wt.eu-S934575AbXHAPR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575AbXHAPR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933193AbXHAPRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:17:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:34877 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864AbXHAPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=JM3oLbaB5wVSmvu9ZNRoJ+LAiRZiUrEY3LQYqMJGSKFl+XUvVbjfFA71UHlHxsqGnJC/LJGADpu7CgYXPJfM6u3mySJHbSaRIDCdKAE0+xDUf5sK9txClawp3IHkm69vvyx2YdsHG2baR/jZLbPBqI58UPKQ9zSxVIJTnqVSK2c=
Message-ID: <46B0A3FB.2080701@googlemail.com>
Date: Wed, 01 Aug 2007 17:17:15 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Coding style fix drivers/scsi/mvme147.c
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

--- linux-mm-clean/drivers/scsi/mvme147.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/scsi/mvme147.c	2007-08-01 17:14:39.000000000 +0200
@@ -13,7 +13,7 @@
 #include "wd33c93.h"
 #include "mvme147.h"
 
-#include<linux/stat.h>
+#include <linux/stat.h>
 
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
