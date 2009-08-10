Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbZHJG4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbZHJG4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZHJG4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:56:22 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52256 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZHJG4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:56:21 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX184w/sm6ZTO7P5T8A8WAtrV
Date: Mon, 10 Aug 2009 09:56:17 +0300
From: Tony Lindgren <tony@atomide.com>
To: Joe Perches <joe@perches.com>
Cc: linux-omap@vger.kernel.org, linux-arm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] MAINTAINERS: Add list entries
	linux-arm@vger.kernel.org and linux-arm-kernel@ to OMAP sections
Message-ID: <20090810065616.GF2358@atomide.com>
References: <1249576450.3467.25.camel@Joe-Laptop.home> <20090807080102.GV2358@atomide.com> <1249657581.3467.76.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249657581.3467.76.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joe Perches <joe@perches.com> [090807 18:07]:
> On Fri, 2009-08-07 at 11:01 +0300, Tony Lindgren wrote:
> > * Joe Perches <joe@perches.com> [090806 19:35]:
> > > Perhaps it's useful for OMAP patches and bug reports
> > > to CC entries to the primary and secondary ARM lists.
> > > Added a pattern entry for OMAP USB as well.
> > ... I think let's not add the drivers. The related driver list
> > and linux-omap list should be enough for these.
> 
> Fine by me.  I fixed up your M: entry as well.

Oh thanks :)
 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b1114cf..6a82733 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3660,8 +3660,10 @@ F:	drivers/video/riva/
>  F:	drivers/video/nvidia/
>  
>  OMAP SUPPORT
> -M:	"Tony Lindgren <tony@atomide.com>" <tony@atomide.com>
> +M:	Tony Lindgren <tony@atomide.com>
>  L:	linux-omap@vger.kernel.org
> +L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm@vger.kernel.org
>  W:	http://www.muru.com/linux/omap/
>  W:	http://linux.omap.com/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
> @@ -3671,12 +3673,16 @@ F:	arch/arm/*omap*
>  OMAP CLOCK FRAMEWORK SUPPORT
>  M:	Paul Walmsley <paul@pwsan.com>
>  L:	linux-omap@vger.kernel.org
> +L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm@vger.kernel.org
>  S:	Maintained
>  F:	arch/arm/*omap*/*clock*
>  
>  OMAP POWER MANAGEMENT SUPPORT
>  M:	Kevin Hilman <khilman@deeprootsystems.com>
>  L:	linux-omap@vger.kernel.org
> +L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> +L:	linux-arm@vger.kernel.org
>  S:	Maintained
>  F:	arch/arm/*omap*/*pm*
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
