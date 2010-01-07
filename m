Return-Path: <linux-kernel-owner+w=401wt.eu-S932601Ab0AGIxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab0AGIxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932521Ab0AGIxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:53:04 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49584 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520Ab0AGIxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:53:01 -0500
Date: Thu, 7 Jan 2010 14:22:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH -mmotm] memcg: implement memory thresholds document fixes
Message-ID: <20100107085256.GU3059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
 <20100107095714.9edc4201.nishimura@mxp.nes.nec.co.jp>
 <20100107101805.b26a1f1a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100107101805.b26a1f1a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-07 10:18:05]:

> On Thu, 7 Jan 2010 09:57:14 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > Each memcg-implement-memory-thresholds.patch and
> > memcg-add-interface-to-move-charge-at-task-migration.patch try to add a new
> > section to Documentation/cgroup/memory.txt, so the document has been a bit
> > mangled when these patches are merged at the same time.
> > 
> > This patch fixes it.
> > 
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> BTW, I'll prepare total update for memcg (especially around percpu counter).
> Do you have something may conflict in plan ?

Kame, could you clarify percpu counter? Is this on for resource
counter scalability patches I had?

-- 
	Balbir
