Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbZIOUhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbZIOUhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZIOUhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:37:20 -0400
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53701 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbZIOUhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:37:19 -0400
X-Greylist: delayed 1621 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2009 16:37:19 EDT
Date: Tue, 15 Sep 2009 12:14:06 -0700 (PDT)
From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
To: Joe Perches <joe@perches.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kalle Valo <kalle.valo@nokia.com>, anil_ravindranath@pmc-sierra.com
Subject: Re: [PATCH] MAINTAINERS: Integrate P:/M: lines
In-Reply-To: <1252980828.3966.7.camel@Joe-Laptop.home>
Message-ID: <alpine.LNX.1.10.0909151212030.17690@rslab159.pmc-sierra.bc.ca>
References: <1252980828.3966.7.camel@Joe-Laptop.home>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 15 Sep 2009 20:10:18.0322 (UTC) FILETIME=[8BB59320:01CA3640]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I checked my section below and changes are fine. Thanks for the changes.

On Mon, 14 Sep 2009, Joe Perches wrote:

> A couple of new uses of separate "P: name" "M: address" lines
> are converted to single line "M: name <address>"
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 837b598..aa545e2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4010,8 +4010,7 @@ F:	drivers/block/pktcdvd.c
>  F:	include/linux/pktcdvd.h
>  
>  PMC SIERRA MaxRAID DRIVER
> -P:	Anil Ravindranath
> -M:	anil_ravindranath@pmc-sierra.com
> +M:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
>  L:	linux-scsi@vger.kernel.org
>  W:	http://www.pmc-sierra.com/
>  S:	Supported
> @@ -5628,8 +5627,7 @@ S:	Maintained
>  F:	drivers/input/misc/wistron_btns.c
>  
>  WL1251 WIRELESS DRIVER
> -P:	Kalle Valo
> -M:	kalle.valo@nokia.com
> +M:	Kalle Valo <kalle.valo@nokia.com>
>  L:	linux-wireless@vger.kernel.org
>  W:	http://wireless.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> 
> 
> 
