Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbYFPHKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbYFPHKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYFPHKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:10:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47748 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760592AbYFPHKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:10:34 -0400
Date: Mon, 16 Jun 2008 16:09:07 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] introduce task cgroup v2
Cc: kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1213599882.16944.90.camel@twins>
References: <20080616155630.78A9.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1213599882.16944.90.camel@twins>
Message-Id: <20080616160802.78AF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > fwiw I think the name sucks!
> > > cgroups are about grouping tasks, so what's a task cgroup?
> > 
> > Sorry, my english skill is very low.
> > I hope restrict number of tasks.
> > 
> > Do you have any name idea?
> 
> Sadly I suck at naming too ;-(
> 
> perhaps task_limit controller, or nr_tasks controller.
> 
> We should preferably pick one that transfers to most other rlimit like
> controls.

Yeah, thanks.
I like "task_limit" controller.

I'll change to it.

very thanks.


