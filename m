Return-Path: <linux-kernel-owner+w=401wt.eu-S936106AbXHMXKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936106AbXHMXKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761249AbXHMXJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:09:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:54922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758712AbXHMXJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:09:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,256,1183359600"; 
   d="scan'208";a="280520810"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [61/2many] MAINTAINERS - ARM/INTEL IOP13XX ARM ARCHITECTURE
Date: Mon, 13 Aug 2007 16:09:49 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5202472724@azsmsx413.amr.corp.intel.com>
In-Reply-To: <46bff8d6.PYudRDbPa4sSlAOV%joe@perches.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [61/2many] MAINTAINERS - ARM/INTEL IOP13XX ARM ARCHITECTURE
Thread-Index: AcfdcnmBpQtyzUOxSce9hjbG+ovi3QAi/84w
References: <46bff8d6.PYudRDbPa4sSlAOV%joe@perches.com>
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: <joe@perches.com>, <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <kernel@wantstofly.org>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 13 Aug 2007 23:09:50.0309 (UTC) FILETIME=[0CB75950:01C7DDFF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: joe@perches.com [mailto:joe@perches.com]
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dd0806c..aaacc55 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -565,6 +565,8 @@ P:	Dan Williams
>  M:	dan.j.williams@intel.com
>  L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
>  S:	Supported
> +F:	arch/arm/mach-iop13xx/
> +F:	include/asm-arm/plat-iop/
> 
>  ARM/INTEL IQ81342EX MACHINE SUPPORT
>  P:	Lennert Buytenhek

For IOP13XX, IOP33X, and IOP32X add:

F: arch/arm/plat-iop/
F: include/asm-arm/hardware/iop*
