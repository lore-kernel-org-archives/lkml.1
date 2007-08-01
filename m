Return-Path: <linux-kernel-owner+w=401wt.eu-S1765779AbXHAPof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765779AbXHAPof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764113AbXHAPoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:44:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:57260 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXHAPoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=dYVh7aC8CJLWUsupjRJRSK1MUT56YhDsR9/Sp+dnuIS8ZjUm0bj9GfpT3rJi7Q8lDI/e5H/PN9dhUGWwutGgsibP/VegBr9cjHHz2+XlYdLVcNkM2MOUlxyg1Z03v4czk534iPzrXF0os/1vgm4ktPespb6kFqnKf7b8+1DDiN8=
Message-ID: <46B0AA38.3050308@googlemail.com>
Date: Wed, 01 Aug 2007 17:43:52 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Coding style fix drivers/serial/icom.h
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

--- linux-mm-clean/drivers/serial/icom.h	2007-07-09 01:32:17.000000000 +0200
+++ linux-mm/drivers/serial/icom.h	2007-08-01 17:41:23.000000000 +0200
@@ -20,7 +20,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#include<linux/serial_core.h>
+#include <linux/serial_core.h>
 
 #define BAUD_TABLE_LIMIT	((sizeof(icom_acfg_baud)/sizeof(int)) - 1)
 static int icom_acfg_baud[] = {
