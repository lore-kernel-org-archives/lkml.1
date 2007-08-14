Return-Path: <linux-kernel-owner+w=401wt.eu-S938259AbXHNCDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938259AbXHNCDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 22:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXHNCDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 22:03:15 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:26734 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbXHNCDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 22:03:14 -0400
Date: Mon, 13 Aug 2007 21:59:45 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: joe@perches.com
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [210/2many] MAINTAINERS - HARDWARE MONITORING
Message-ID: <20070814015945.GC7748@jupiter.solarsys.private>
References: <46bffa04.JW3S0ykNGAQACMv1%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffa04.JW3S0ykNGAQACMv1%joe@perches.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe:

* joe@perches.com <joe@perches.com> [2007-08-12 23:28:20 -0700]:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e35e29c..f422277 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2015,6 +2015,7 @@ L:	lm-sensors@lm-sensors.org
>  W:	http://www.lm-sensors.org/
>  T:	git lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git
>  S:	Maintained
> +F:	drivers/hwmon/
>  
>  HARDWARE RANDOM NUMBER GENERATOR CORE
>  P:	Michael Buesch

I guess you know by now not to ever do that again.

If you collect the hwmon stuff into one (1) patch, I'll take it.

Now you'll excuse me while I drive a nail through my delete key.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

