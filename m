Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbXGFWc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbXGFWc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759816AbXGFWcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:32:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35111 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709AbXGFWcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:32:20 -0400
Date: Sat, 7 Jul 2007 07:31:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, clameter@sgi.com,
       mel@csn.ul.ie
Subject: Re: [PATCH] memory unplug v7 [4/6] - page isolation
Message-Id: <20070707073157.122d4d55.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070706152828.9ae57453.akpm@linux-foundation.org>
References: <20070706181903.428c3713.kamezawa.hiroyu@jp.fujitsu.com>
	<20070706182611.b16b6720.kamezawa.hiroyu@jp.fujitsu.com>
	<20070706152828.9ae57453.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007 15:28:28 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 6 Jul 2007 18:26:11 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > +/*
> > + * start_isolate_page_range() -- make page-allocation-type of range of pages
> > + * to be MIGRATE_ISOLATE.
> 
> I think kerneldoc requires that the above all be on a single line.
> 
Hmm...I'll read it again and fix this.

Thanks,
-Kame

