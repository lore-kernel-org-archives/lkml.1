Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbZACH3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbZACH3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZACH3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:29:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:33348 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750767AbZACH3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:29:32 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/FdtwFTIzFinMEjaHQtQMFNVHbwcaw74osiILhKv
	wyiYZMNP7goJ4F
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090102221630.GF17240@elte.hu>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
	 <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com>
	 <20081230024819.GA23301@balbir.in.ibm.com> <20081230062139.GA30038@elte.hu>
	 <20081230180722.GA29060@dirshya.in.ibm.com>
	 <20090102072600.GA13412@dirshya.in.ibm.com>
	 <20090102221630.GF17240@elte.hu>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 08:29:25 +0100
Message-Id: <1230967765.5257.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-02 at 23:16 +0100, Ingo Molnar wrote:

> Mike, would you be interesting in having a look at sched_mc=2 as a 
> kernel-wide default - and give it your blessing if you find it to be a net 
> improvement for the various performance and interactivity tests you do?

Sure.

	-Mike

