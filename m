Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbZACKNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbZACKNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZACKNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:13:35 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:39098 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZACKNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:13:34 -0500
Date: Sat, 3 Jan 2009 15:46:26 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20090103101626.GA4301@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com> <20081230024819.GA23301@balbir.in.ibm.com> <20081230062139.GA30038@elte.hu> <20081230180722.GA29060@dirshya.in.ibm.com> <20090102072600.GA13412@dirshya.in.ibm.com> <20090102221630.GF17240@elte.hu> <1230967765.5257.6.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1230967765.5257.6.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2009-01-03 08:29:25]:

> On Fri, 2009-01-02 at 23:16 +0100, Ingo Molnar wrote:
> 
> > Mike, would you be interesting in having a look at sched_mc=2 as a 
> > kernel-wide default - and give it your blessing if you find it to be a net 
> > improvement for the various performance and interactivity tests you do?
> 
> Sure.

Thanks Mike and Ingo.  I will be glad to help with test and benchmarks
on the platforms that I have access.

I am presently working on sysbench.

--Vaidy
