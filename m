Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbXI3J7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbXI3J7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 05:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXI3J7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 05:59:12 -0400
Received: from trinity.fluff.org ([217.147.94.151]:2173 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbXI3J7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 05:59:11 -0400
X-Greylist: delayed 3257 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2007 05:59:11 EDT
Date: Sun, 30 Sep 2007 10:04:39 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben@simtec.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Tweak Documentation/SM501.txt
Message-ID: <20070930090439.GA29706@trinity.fluff.org>
References: <200709292215.12893.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709292215.12893.rob@landley.net>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 10:15:12PM -0500, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> The existing Documentation/SM501.txt gives no clue what the chip is or does,
> so copy the description from Kconfig help text.
> 
> cc: Ben Dooks <ben@simtec.co.uk>
Acked-by: Ben Dooks <ben-linux@fluff.org> 
> Signed-off-by: Rob Landley <rob@landley.net>
> ---
> 
>  Documentation/SM501.txt |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff -r dc28e4e17791 Documentation/SM501.txt
> --- a/Documentation/SM501.txt	Wed Sep 26 15:52:17 2007 -0700
> +++ b/Documentation/SM501.txt	Sat Sep 29 14:01:43 2007 -0500
> @@ -2,6 +2,11 @@
>  			============
>  
>  Copyright 2006, 2007 Simtec Electronics
> +
> +The Silicon Motion SM501 multimedia companion chip is a multifunction device
> +which may provide numerous interfaces including USB host controller USB gadget,
> +Asyncronous Serial ports, Audio functions and a dual display video interface.
> +The device may be connected by PCI or local bus with varying functions enabled.
>  
>  Core
>  ----

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

