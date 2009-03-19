Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbZCSJY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbZCSJY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZCSJYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:24:48 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49432 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZCSJYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:24:47 -0400
Date: Thu, 19 Mar 2009 14:54:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v3
Message-ID: <20090319092429.GF16897@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090317062155.GE3314@in.ibm.com> <1237454248.7867.24.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1237454248.7867.24.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-03-19 10:17:28]:

> On Tue, 2009-03-17 at 11:51 +0530, Bharata B Rao wrote:
> > Hi,
> > 
> > Here is the next version of the cpuacct stime/utime statistics patch.
> > 
> > Ingo, Could you please consider this for -tip ?
> > 
> > Changes for v3:
> > - Fix a small race in the cpuacct hierarchy walk.
> > 
> > v2:
> > http://lkml.org/lkml/2009/3/12/170
> > 
> > v1:
> > http://lkml.org/lkml/2009/3/10/150
> > --
> > 
> > cpuacct: Add stime and utime statistics
> > 
> > Add per-cgroup cpuacct controller statistics like the system and user
> > time consumed by the group of tasks.
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > Signed-off-by: Balaji Rao <balajirrao@gmail.com>
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
 
Sorry, I should done this earlier


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
