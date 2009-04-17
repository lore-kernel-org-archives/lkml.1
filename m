Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbZDQHsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbZDQHsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbZDQHsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:48:46 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:54077 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756059AbZDQHsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:48:45 -0400
Date: Fri, 17 Apr 2009 16:48:44 +0900 (JST)
Message-Id: <20090417.164844.59671177.ryov@valinux.co.jp>
To: akpm@linux-foundation.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com, menage@google.com,
       balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       agk@sourceware.org, axboe@kernel.dk, baramsori72@gmail.com,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090416211514.038c5e91.akpm@linux-foundation.org>
References: <20090416174428.6bb5da21.akpm@linux-foundation.org>
	<20090417.104432.193700511.ryov@valinux.co.jp>
	<20090416211514.038c5e91.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/9] bio-cgroup controller
Date: Thu, 16 Apr 2009 21:15:14 -0700

> On Fri, 17 Apr 2009 10:44:32 +0900 (JST) Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> 
> > > > Hmm, how about iotrack-cgroup ?
> > > > 
> > > 
> > > Well. blockio_cgroup has the same character count and is more specific.
> > 
> > How about blkio_cgroup ?
> 
> Sounds good.

I'll rename bio-cgroup to blkio_cgroup and post the patches to this
list nextweek.

Thanks,
Ryo Tsuruta
