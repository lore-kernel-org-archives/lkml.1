Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbYLFDmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbYLFDmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 22:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYLFDmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 22:42:38 -0500
Received: from rcpt-expgw.biglobe.ne.jp ([133.205.19.67]:48333 "EHLO
	rcpt-expgw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbYLFDmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 22:42:37 -0500
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Sat, 6 Dec 2008 12:42:23 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       d-nishimura@mtf.biglobe.ne.jp
Subject: Re: [RFC][PATCH -mmotm 0/4] patches for memory cgroup (20081205)
Message-Id: <20081206124223.665d7d3c.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
References: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008 21:22:08 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi.
> 
> These are patches that I have now.
> 
> Patches:
>   [1/4] memcg: don't trigger oom at page migration
>   [2/4] memcg: remove mem_cgroup_try_charge
>   [3/4] memcg: avoid deadlock caused by race between oom and cpuset_attach
>   [4/4] memcg: change try_to_free_pages to hierarchical_reclaim
> 
> There is no special meaning in patch order except for 1 and 2.
> 
> Any comments would be welcome.
> 
Thank you for all your reviews and acks.

I'll send them to Andrew after I back to my office on Monday.


Thanks,
Daisuke Nishimura.
