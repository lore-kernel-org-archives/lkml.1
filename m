Return-Path: <linux-kernel-owner+w=401wt.eu-S937195AbXHMPfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937195AbXHMPfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973171AbXHMNd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:33:58 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:42769 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S973137AbXHMNdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:33:53 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
Date: Mon, 13 Aug 2007 09:33:51 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01D12A93@otce2k301.adaptec.com>
In-Reply-To: <46bff88b.U/STkuzaGFGAV6x7%joe@perches.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
Thread-Index: AcfdckZvH9YwGp4HSnWIGgWIaOLlXQAPEQmQ
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: <joe@perches.com>, <torvalds@linux-foundation.org>,
       <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, "AACRAID" <aacraid@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: joe@perches.com [mailto:joe@perches.com] 
> Sent: Monday, August 13, 2007 2:22 AM
> To: torvalds@linux-foundation.org; 
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; 
> akpm@linux-foundation.org; AACRAID
> Subject: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
> 
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7d58f6b..1162fb7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -241,6 +241,7 @@ M:	aacraid@adaptec.com
>  L:	linux-scsi@vger.kernel.org
>  W:	http://www.adaptec.com/
>  S:	Supported
> +F:	drivers/scsi/aacraid/
>  
>  ACPI
>  P:	Len Brown
> 
