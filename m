Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab0BCCPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 21:15:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40921 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab0BCCPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 21:15:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 3 Feb 2010 11:12:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Lubos Lunak <l.lunak@suse.cz>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Nick Piggin <npiggin@suse.de>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
Message-Id: <20100203111224.8fe0e20c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002021809220.15327@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz>
	<alpine.DEB.2.00.1002011523280.19457@chino.kir.corp.google.com>
	<201002022210.06760.l.lunak@suse.cz>
	<alpine.DEB.2.00.1002021643240.3393@chino.kir.corp.google.com>
	<20100203105236.b4a60754.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002021809220.15327@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010 18:12:41 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 3 Feb 2010, KAMEZAWA Hiroyuki wrote:
> 
> > I stopped that as I mentioned. I'm heavily disappointed with myself and
> > would like not to touch oom-killer things for a while.
> > 
> > I'd like to conentrate on memcg for a while, which I've starved for these 3 months.
> > 
> > Then, you don't need to CC me.
> > 
> 
> I'm disappointed to hear that, it would be helpful to get some consensus 
> on the points that we can all agree on from different perspectives.  I'll 
> try to find some time to develop a solution that people will see as a move 
> in the positive direction.
> 
> On a seperate topic, do you have time to repost your sysctl cleanup for 
> Andrew from http://marc.info/?l=linux-kernel&m=126457416729672 with the
> #ifndef CONFIG_MMU fix I mentioned?
> 
I'll not. Feel free to reuse fragments I posted.

Thanks,
-Kame

