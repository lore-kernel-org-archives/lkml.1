Return-Path: <linux-kernel-owner+w=401wt.eu-S947912AbXHMQZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947912AbXHMQZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967421AbXHMPQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:16:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:14173 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967113AbXHMPQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,255,1183359600"; 
   d="scan'208";a="262458940"
Message-ID: <46C075AF.4000103@intel.com>
Date: Mon, 13 Aug 2007 08:15:59 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, e1000-devel@lists.sourceforge.net,
       cramerj@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH] [257/2many] MAINTAINERS - INTEL PRO/1000 GIGABIT ETHERNET
 SUPPORT
References: <46bffa66.QCw+66otGbnO9zGl%joe@perches.com>
In-Reply-To: <46bffa66.QCw+66otGbnO9zGl%joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2007 15:16:34.0713 (UTC) FILETIME=[EF9F4090:01C7DDBC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c4a3480..4cf1579 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2453,6 +2453,7 @@ M:	auke-jan.h.kok@intel.com
>  L:	e1000-devel@lists.sourceforge.net
>  W:	http://sourceforge.net/projects/e1000/
>  S:	Supported
> +F:	drivers/net/e100.c
>  
>  INTEL PRO/10GbE SUPPORT
>  P:	Jeff Kirsher


that would be horribly wrong looking at the subject: drivers/net/e1000/ would be 
more appropriate.

Auke
