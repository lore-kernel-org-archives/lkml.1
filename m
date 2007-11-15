Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbXKOJVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbXKOJVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 04:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756580AbXKOJUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 04:20:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34142 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbXKOJUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 04:20:47 -0500
Date: Thu, 15 Nov 2007 18:18:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc2-mm1 (memory hotplug x86_64/vmemmap  fix)
Message-Id: <20071115181816.1f0cb905.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071115005657.99856c28.akpm@linux-foundation.org>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115132919.f2bf4946.kamezawa.hiroyu@jp.fujitsu.com>
	<20071115005657.99856c28.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 00:56:57 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> eek.
> 
> What I now need to do with this patch is
> 
> - Work out which patches in -mm it is actually fixing.
> 
> - If that is more than one patch then split this patch up into multiple ones.
> 
> - Stage the one or more fixup patches immediately after the patches which
>   they are fixing (with appropriate names: foo-fix.patch fixes foo.patch)
> 
> And that's OK - it's what I do.  But if you already have some idea which
> patch you're actually fixing then it really helps me if you can tell me
> which one it was, please - there's no point in having me duplicate your
> work.
> 
> Plus it does look like this is three patches in one (at least)...
> 
> Thanks.
> 
Sorry, I'll divide them and repost with suitable explanation, soon.

Thanks,
-Kame

