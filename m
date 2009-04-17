Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZDQEb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZDQEb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZDQEbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:31:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbZDQEbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:31:47 -0400
Date: Thu, 16 Apr 2009 21:15:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryo Tsuruta <ryov@valinux.co.jp>
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
Message-Id: <20090416211514.038c5e91.akpm@linux-foundation.org>
In-Reply-To: <20090417.104432.193700511.ryov@valinux.co.jp>
References: <20090416152937.b2188370.akpm@linux-foundation.org>
	<20090417092040.1c832c69.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416174428.6bb5da21.akpm@linux-foundation.org>
	<20090417.104432.193700511.ryov@valinux.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 10:44:32 +0900 (JST) Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> > > Hmm, how about iotrack-cgroup ?
> > > 
> > 
> > Well. blockio_cgroup has the same character count and is more specific.
> 
> How about blkio_cgroup ?

Sounds good.
