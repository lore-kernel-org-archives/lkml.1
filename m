Return-Path: <linux-kernel-owner+w=401wt.eu-S940985AbXHNFVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940985AbXHNFVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933663AbXHNFVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:21:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:64713 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080AbXHNFVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:21:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,257,1183359600"; 
   d="scan'208";a="117221249"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [28/2many] MAINTAINERS - ACPI VIDEO DRIVER
Date: Tue, 14 Aug 2007 13:21:07 +0800
Message-ID: <823A93EED437D048963A3697DB0E35DE97EC9A@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <200708140116.30199.lenb@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [28/2many] MAINTAINERS - ACPI VIDEO DRIVER
Thread-Index: AcfeMkuX5BXbDIM6Rw+nv3izzr3SCwAAB2Jg
References: <46bff898.QBRdcCdpCAEm8W02%joe@perches.com> <200708140116.30199.lenb@kernel.org>
From: "Zhang, Rui" <rui.zhang@intel.com>
To: "Len Brown" <lenb@kernel.org>, <joe@perches.com>
Cc: <torvalds@linux-foundation.org>, "Yu, Luming" <luming.yu@intel.com>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 14 Aug 2007 05:21:11.0789 (UTC) FILETIME=[ED8361D0:01C7DE32]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Len,

I can take charge of the ACPI video driver.

Thanks,
Rui

-----Original Message-----
From: Len Brown [mailto:lenb@kernel.org] 
Sent: Tuesday, August 14, 2007 1:16 PM
To: joe@perches.com; Zhang, Rui
Cc: torvalds@linux-foundation.org; Yu, Luming;
linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org;
akpm@linux-foundation.org
Subject: Re: [PATCH] [28/2many] MAINTAINERS - ACPI VIDEO DRIVER

On Monday 13 August 2007 02:22, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b159b00..4faf1ce 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -300,6 +300,7 @@ M:	luming.yu@intel.com
>  L:	linux-acpi@vger.kernel.org
>  W:	http://acpi.sourceforge.net/
>  S:	Supported
> +F:	drivers/acpi/video.c

Acked-by: Len Brown <len.brown@intel.com>

Also, as Luming has moved onto other things, and Rui is shy
about being in MAINTAINERS as yet...  Please update to

P:	Len Brown
M: 	len.brown@intel.com

while you are there.

thanks,
-Len

>  ADM1025 HARDWARE MONITOR DRIVER
>  P:	Jean Delvare
> -
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
