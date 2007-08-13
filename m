Return-Path: <linux-kernel-owner+w=401wt.eu-S972892AbXHMNXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972892AbXHMNXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S941100AbXHMJSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:18:24 -0400
Received: from ip78-183-211-87.adsl2.versatel.nl ([87.211.183.78]:2821 "EHLO
	god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939282AbXHMJSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:18:22 -0400
X-Greylist: delayed 1353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 05:18:22 EDT
Date: Mon, 13 Aug 2007 10:55:45 +0200
From: Henk Vergonet <Henk.Vergonet@gmail.com>
To: joe@perches.com
Cc: usbb2k-api-dev@nongnu.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [550/2many] MAINTAINERS - YEALINK PHONE DRIVER
Message-ID: <20070813085545.GA1478@god.dyndns.org>
References: <46bffcbe.s0MfgQHyJjfXBlZH%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffcbe.s0MfgQHyJjfXBlZH%joe@perches.com>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:39:58PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2773da9..351e6bf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5206,6 +5206,8 @@ P:	Henk Vergonet
>  M:	Henk.Vergonet@gmail.com
>  L:	usbb2k-api-dev@nongnu.org
>  S:	Maintained
> +F:	Documentation/input/yealink.txt
> +F:	drivers/input/misc/yealink.*

You might want to add:
  +F:	drivers/input/misc/map_to_7segment.h

>  
>  Z8530 DRIVER FOR AX.25
>  P:	Joerg Reuter

Thanks,

Henk Vergonet
