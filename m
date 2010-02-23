Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0BWG0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:26:25 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38529 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0BWG0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:26:24 -0500
Date: Tue, 23 Feb 2010 15:21:16 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       rientjes@google.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] memcg: page fault oom improvement
Message-Id: <20100223152116.327a777e.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100223140218.0ab8ee29.nishimura@mxp.nes.nec.co.jp>
References: <20100223120315.0da4d792.kamezawa.hiroyu@jp.fujitsu.com>
	<20100223140218.0ab8ee29.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 14:02:18 +0900, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> On Tue, 23 Feb 2010 12:03:15 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Nishimura-san, could you review and test your extreme test case with this ?
> > 
> Thank you for your patch.
> I don't know why, but the problem seems not so easy to cause in mmotm as in 2.6.32.8,
> but I'll try more anyway.
> 
I can triggered the problem in mmotm.

I'll continue my test with your patch applied.


Thanks,
Daisuke Nishimura.
