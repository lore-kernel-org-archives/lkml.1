Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbZFYRNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbZFYRNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZFYRNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:13:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49342 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZFYRNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:13:30 -0400
Message-ID: <4A43B060.30904@garzik.org>
Date: Thu, 25 Jun 2009 13:14:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ion Badulescu <ionut@badula.org>, NetDev <netdev@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: STARFIRE/DURALAN update
References: <1245946630.395.37.camel@Joe-Laptop.home>
In-Reply-To: <1245946630.395.37.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fa2a16d..218126a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5533,8 +5533,8 @@ F:	drivers/staging/
>  
>  STARFIRE/DURALAN NETWORK DRIVER
>  P:	Ion Badulescu
> -M:	ionut@cs.columbia.edu
> -S:	Maintained
> +M:	ionut@badula.org
> +S:	Odd Fixes
>  F:	drivers/net/starfire*
>  
>  STARMODE RADIO IP (STRIP) PROTOCOL DRIVER

This change needs a better explanation, and should be CC'd to netdev 
since it relates to network drivers.

	Jeff



