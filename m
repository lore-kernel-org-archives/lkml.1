Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYLIJGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYLIJGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 04:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYLIJGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 04:06:24 -0500
Received: from tundra.namei.org ([65.99.196.166]:1689 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbYLIJGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 04:06:23 -0500
Date: Tue, 9 Dec 2008 20:05:52 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] user namespaces: document CFS behavior
In-Reply-To: <20081209024543.GA11538@elte.hu>
Message-ID: <alpine.LRH.1.10.0812092005100.10841@tundra.namei.org>
References: <20081208215221.GA3954@us.ibm.com> <alpine.LRH.1.10.0812090927350.8505@tundra.namei.org> <20081209024543.GA11538@elte.hu>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008, Ingo Molnar wrote:

> hm, i'd rather carry these in the scheduler tree as we've got some 
> changes in this area already and because these are arguably scheduler 
> changes:
> 
>  Documentation/scheduler/sched-design-CFS.txt |   21 +++++++++++++++++++++
>  kernel/user.c                                |    8 +++++++-
> 
> the incompleteness of CONFIG_USER_SCHED is not addressed yet.
> 
> Ok?

They're already published in my tree.  Do you want me to revert them?


-- 
James Morris
<jmorris@namei.org>
