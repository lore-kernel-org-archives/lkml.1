Return-Path: <linux-kernel-owner+w=401wt.eu-S932284AbXIJKjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbXIJKjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbXIJKjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:39:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36829 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbXIJKjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:39:24 -0400
Date: Mon, 10 Sep 2007 19:41:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] add page->mapping handling interface [22/35] changes in
 JFFS2
Message-Id: <20070910194116.b4bfe271.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1189419591.8320.161.camel@pmac.infradead.org>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20070910191622.d18b1aaa.kamezawa.hiroyu@jp.fujitsu.com>
	<1189419591.8320.161.camel@pmac.infradead.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 11:19:51 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2007-09-10 at 19:16 +0900, KAMEZAWA Hiroyuki wrote:
> > Changes page->mapping handling in JFFS2
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Looks reasonable to me; I assume it's not intended for me to take it and
> apply it yet, before the core parts are merged? I'll let you shepherd it
> upstream...
> 
Ah, no. core patches are not merged. This patch's target is -mm, now.
I just CC:ed to each FS maintainers to show what this patch set does.

Thanks,
-Kame

