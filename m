Return-Path: <linux-kernel-owner+w=401wt.eu-S1763857AbXHMOzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763857AbXHMOzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969408AbXHMMSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:18:10 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:27985 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965954AbXHMMSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:18:07 -0400
Date: Mon, 13 Aug 2007 15:18:03 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, mulix@mulix.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [481/2many] MAINTAINERS - TRIDENT 4DWAVE/SIS 7018 PCI AUDIO CORE
Message-ID: <20070813121803.GB1374@rhun.haifa.ibm.com>
References: <46bffc25.miV0BBr9F/41UwE2%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffc25.miV0BBr9F/41UwE2%joe@perches.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:37:25PM -0700, joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7927653..fbd699e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4563,6 +4563,7 @@ P:	Muli Ben-Yehuda
>  M:	mulix@mulix.org
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> +F:	sound/pci/trident/

Nope, this entry is for sound/oss/trident*.

Cheers,
Muli
