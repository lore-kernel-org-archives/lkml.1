Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab0BZF1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:27:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59783 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0BZF1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:27:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Feb 2010 14:23:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       rientjes@google.com
Subject: Re: [RFC][PATCH 1/2] memcg: oom kill handling improvement
Message-Id: <20100226142339.7a67f1a8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100226131552.07475f9c.nishimura@mxp.nes.nec.co.jp>
References: <20100224165921.cb091a4f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100226131552.07475f9c.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 13:15:52 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Wed, 24 Feb 2010 16:59:21 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > These are dump of patches just for showing concept, what I want to do.
> > But not tested. please see if you have free time. (you can ignore ;)
> > 
> > Anyway, this will HUNK to the latest mmotm, Kirill's work is merged.
> > 
> > This is not related to David's work. I don't hesitate to rebase mine
> > to the mmotm if his one is merged, it's easy.
> > But I'm not sure his one goes to mm soon. 
> > 
> > 1st patch is for better handling oom-kill under memcg.
> It's bigger than I expected, but it basically looks good to me.
> 

BTW, do you think we need quick fix ? I can't think of a very easy/small fix
which is very correct...

Thanks,
-Kame

