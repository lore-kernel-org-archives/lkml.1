Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab0CDGSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 01:18:25 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:55228 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab0CDGSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 01:18:23 -0500
Date: Thu, 4 Mar 2010 15:14:28 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       balbir@linux.vnet.ibm.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: update mainteiner list
Message-Id: <20100304151428.d2c0f019.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100304145030.22a35a7e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100304145030.22a35a7e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 14:50:30 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Updates for maintainer list of memcg.
> I'd like to add Nishimura-san to maintainer of memcg, he works really well.
> And I'm sorry that I've not seen Pavel on memcg discussion for a year.
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Nishimura-san have been working for memcg very good.
> His review and tests give us much improvements and account migraiton
> which he is now challenging is really important.
> 
> He is a stakeholder.
> 
Ack the part of adding my name.

Thanks,
Daisuke Nishimura.

> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: mmotm-2.6.33-Mar2/MAINTAINERS
> ===================================================================
> --- mmotm-2.6.33-Mar2.orig/MAINTAINERS
> +++ mmotm-2.6.33-Mar2/MAINTAINERS
> @@ -3675,7 +3675,7 @@ F:	mm/
>  
>  MEMORY RESOURCE CONTROLLER
>  M:	Balbir Singh <balbir@linux.vnet.ibm.com>
> -M:	Pavel Emelyanov <xemul@openvz.org>
> +M:	Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>  M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> 
