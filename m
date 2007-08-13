Return-Path: <linux-kernel-owner+w=401wt.eu-S945087AbXHMMGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945087AbXHMMGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967535AbXHMGkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965208AbXHMGkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:12 -0400
Message-ID: <46BFFCA0.3090600@redhat.com>
Date: Mon, 13 Aug 2007 02:39:28 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jcliburn@gmail.com, atl1-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [74/2many] MAINTAINERS - ATL1 ETHERNET DRIVER
References: <46bff8ef./PAU8OU4FL0OGX8r%joe@perches.com>
In-Reply-To: <46bff8ef./PAU8OU4FL0OGX8r%joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b8bb108..d9d1bcc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -752,6 +752,7 @@ L:	atl1-devel@lists.sourceforge.net
>  W:	http://sourceforge.net/projects/atl1
>  W:	http://atl1.sourceforge.net
>  S:	Maintained
> +F:	drivers/net/atl1*
>  
>  ATM
>  P:	Chas Williams

atl1 has its own directory, so this one should read

F:	drivers/net/atl1/*

	-- Chris
