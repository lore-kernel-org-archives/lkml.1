Return-Path: <linux-kernel-owner+w=401wt.eu-S943676AbXHMJqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943676AbXHMJqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967117AbXHMGdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:31 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:15203 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967094AbXHMGdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:21 -0400
Date: Mon, 13 Aug 2007 09:33:18 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] [2/2many] - FInd the maintainer(s) for a patch - MAINTAINERS
Message-ID: <20070813063318.GC3645@rhun.haifa.ibm.com>
References: <1186984399.10249.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186984399.10249.10.camel@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 10:53:19PM -0700, Joe Perches wrote:
> Describe the new F: pattern

Patch looks reversed?

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0d7f856..d3a0684 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -83,13 +83,6 @@ S: Status, one of the following:
>  			it has been replaced by a better system and you
>  			should be using that.
>  
> -F: Files and directories with wildcard patterns.
> -   A trailing slash includes all files and subdirectory files.
> -	F:	drivers/net/	all files in and below drivers/net
> -	F:	drivers/net/*	all files in drivers/net, but not below
> -	F:	*/net/*		all files in "any top level directory"/net
> -   One pattern per line.  Multiple F: lines acceptable.
> -
>  3C359 NETWORK DRIVER
>  P:	Mike Phillips
>  M:	mikep@linuxtr.net

Cheers,
Muli
