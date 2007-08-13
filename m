Return-Path: <linux-kernel-owner+w=401wt.eu-S1030961AbXHMNCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030961AbXHMNCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943230AbXHMIMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:12:55 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58129 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S943229AbXHMIMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:12:53 -0400
Message-ID: <46C01284.4060608@s5r6.in-berlin.de>
Date: Mon, 13 Aug 2007 10:12:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, ben.collins@ubuntu.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [244/2many] MAINTAINERS - IEEE 1394 SUBSYSTEM
References: <46bffa48.AcyjF9YPK9VTFwNb%joe@perches.com>
In-Reply-To: <46bffa48.AcyjF9YPK9VTFwNb%joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2063c0f..26c460a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2312,6 +2312,7 @@ L:	linux1394-devel@lists.sourceforge.net
>  W:	http://www.linux1394.org/
>  T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
>  S:	Maintained
> +F:	drivers/ieee/1394/

Wrong path.
+F:	drivers/ieee1394/

>  
>  IEEE 1394 RAW I/O DRIVER (raw1394)
>  P:	Dan Dennedy



-- 
Stefan Richter
-=====-=-=== =--- -==-=
http://arcgraph.de/sr/
