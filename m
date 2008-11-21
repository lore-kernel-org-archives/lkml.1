Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYKUFqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYKUFqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 00:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYKUFqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 00:46:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54979 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYKUFqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 00:46:10 -0500
Date: Fri, 21 Nov 2008 14:45:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] memcg: fix a typo in Kconfig
Message-Id: <20081121144525.cdb72a9a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49263218.1090305@cn.fujitsu.com>
References: <49263218.1090305@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 11:59:20 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> s/contoller/controller
> 
> Signed-of-by: Li Zefan <lizf@cn.fujitsu.com>
Thanks,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  init/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index f763762..8767393 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -414,7 +414,7 @@ config CGROUP_MEM_RES_CTLR
>  	  sure you need the memory resource controller. Even when you enable
>  	  this, you can set "cgroup_disable=memory" at your boot option to
>  	  disable memory resource controller and you can avoid overheads.
> -	  (and lose benefits of memory resource contoller)
> +	  (and lose benefits of memory resource controller)
>  
>  	  This config option also selects MM_OWNER config option, which
>  	  could in turn add some fork/exit overhead.
> -- 
> 1.5.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

