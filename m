Return-Path: <linux-kernel-owner+w=401wt.eu-S934952AbXHMXEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934952AbXHMXEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbXHMXDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:03:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:5289 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbXHMXDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:03:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,256,1183359600"; 
   d="scan'208";a="262658033"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [253/2many] MAINTAINERS - INTEL IOP-ADMA DMA DRIVER
Date: Mon, 13 Aug 2007 16:03:44 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5202472711@azsmsx413.amr.corp.intel.com>
In-Reply-To: <46bffa59.ydZjAhAKpNNtyksl%joe@perches.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [253/2many] MAINTAINERS - INTEL IOP-ADMA DMA DRIVER
Thread-Index: Acfdc17Xg7/tGa4hQz+kMdFyL0/fIwAir3DA
References: <46bffa59.ydZjAhAKpNNtyksl%joe@perches.com>
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: <joe@perches.com>, <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
X-OriginalArrivalTime: 13 Aug 2007 23:03:45.0521 (UTC) FILETIME=[33491E10:01C7DDFE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: joe@perches.com [mailto:joe@perches.com]
> Sent: Sunday, August 12, 2007 11:30 PM
> To: torvalds@linux-foundation.org; linux-kernel@vger.kernel.org;
Williams, Dan
> J; akpm@linux-foundation.org
> Subject: [PATCH] [253/2many] MAINTAINERS - INTEL IOP-ADMA DMA DRIVER
> 
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 773dd76..da059b9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2410,6 +2410,7 @@ P:	Dan Williams
>  M:	dan.j.williams@intel.com
>  L:	linux-kernel@vger.kernel.org
>  S:	Supported
> +F:	drivers/dma/ioatdma*
> 
>  INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
>  P:	Deepak Saxena

Acked-by: Dan Williams <dan.j.williams@intel.com>
