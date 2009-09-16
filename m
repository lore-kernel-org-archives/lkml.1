Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZIPHzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZIPHzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZIPHzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:55:19 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55292 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZIPHzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:55:18 -0400
Date: Wed, 16 Sep 2009 16:51:29 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: memcg merge for 2.6.32 (was Re: 2.6.32 -mm merge plans)
Message-Id: <20090916165129.a75879ae.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090916073727.GP4846@balbir.in.ibm.com>
References: <20090915161535.db0a6904.akpm@linux-foundation.org>
	<20090916073727.GP4846@balbir.in.ibm.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 13:07:27 +0530, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Andrew Morton <akpm@linux-foundation.org> [2009-09-15 16:15:35]:
> 
> > 
> > memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
> > memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
> > memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
> > #memcg-add-comments-explaining-memory-barriers.patch: needs update (Balbir)
> > memcg-add-comments-explaining-memory-barriers.patch
> > memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
> > memory-controller-soft-limit-documentation-v9.patch
> > memory-controller-soft-limit-interface-v9.patch
> > memory-controller-soft-limit-organize-cgroups-v9.patch
> > memory-controller-soft-limit-organize-cgroups-v9-fix.patch
> > memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
> > memory-controller-soft-limit-reclaim-on-contention-v9.patch
> > memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
> > memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
> > memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
> > memcg-improve-resource-counter-scalability.patch
> > memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
> > memcg-improve-resource-counter-scalability-v5.patch
> > memcg-show-swap-usage-in-stat-file.patch
> > memcg-show-swap-usage-in-stat-file-fix.patch
> > 
> >   Merge after checking with Balbir
> 
> 
> I think these are ready for merging, I'll let Kame and Daisuke comment
> on it more. The resource counter scalability patch is the most
> important patch in the series.
> 
I don't have any objection for merging these patches.


Daisuke Nishimura.
