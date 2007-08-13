Return-Path: <linux-kernel-owner+w=401wt.eu-S945679AbXHMNBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945679AbXHMNBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943052AbXHMIML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:12:11 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58122 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936783AbXHMIMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:12:08 -0400
Message-ID: <46C01257.5050605@s5r6.in-berlin.de>
Date: Mon, 13 Aug 2007 10:12:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dan@dennedy.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [245/2many] MAINTAINERS - IEEE 1394 RAW I/O DRIVER (raw1394)
References: <46bffa4a.mbhE/dzTT9J4IluU%joe@perches.com>
In-Reply-To: <46bffa4a.mbhE/dzTT9J4IluU%joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>

ACK.

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 26c460a..7889eb8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2321,6 +2321,7 @@ P:	Stefan Richter
>  M:	stefanr@s5r6.in-berlin.de
>  L:	linux1394-devel@lists.sourceforge.net
>  S:	Maintained
> +F:	drivers/ieee1394/raw1394*
>  
>  IMS TWINTURBO FRAMEBUFFER DRIVER
>  P:	Paul Mundt


-- 
Stefan Richter
-=====-=-=== =--- -==-=
http://arcgraph.de/sr/
