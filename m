Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbXGSEqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbXGSEqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 00:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbXGSEqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 00:46:25 -0400
Received: from 1wt.eu ([62.212.114.60]:3566 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbXGSEqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 00:46:25 -0400
Date: Thu, 19 Jul 2007 06:46:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: Li Yang <leo@zh-kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update 2.4 maintainer in document
Message-ID: <20070719044621.GB30890@1wt.eu>
References: <1183921507.6235.31.camel@leo-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183921507.6235.31.camel@leo-desktop>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 03:05:07AM +0800, Li Yang wrote:
> Update the maintainer of 2.4 kernel in Documentations/SubmittingPatches.

Thanks, but you should have CCed me, because I missed you mail ;-)
I'll merge it.

Regards,
Willy

> Signed-off-by: Li Yang <leo@zh-kernel.org>
> ---
>  Documentation/SubmittingDrivers |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/SubmittingDrivers
> b/Documentation/SubmittingDrivers
> index d7e2642..24f2eb4 100644
> --- a/Documentation/SubmittingDrivers
> +++ b/Documentation/SubmittingDrivers
> @@ -36,8 +36,7 @@ Linux 2.4:
>  	If the code area has a general maintainer then please submit it to
>  	the maintainer listed in MAINTAINERS in the kernel file. If the
>  	maintainer does not respond or you cannot find the appropriate
> -	maintainer then please contact Marcelo Tosatti
> -	<marcelo.tosatti@cyclades.com>.
> +	maintainer then please contact Willy Tarreau <w@1wt.eu>.
>  
>  Linux 2.6:
>  	The same rules apply as 2.4 except that you should follow linux-kernel
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
