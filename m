Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXIYOA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXIYOA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbXIYOAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:00:18 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:52913 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbXIYOAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:00:16 -0400
Subject: Re: 2.6.23-rc7-mm1: panic in scheduler
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <46F8C09F.4050707@linux.vnet.ibm.com>
References: <1190668373.5030.10.camel@localhost>
	 <46F82C88.1080907@linux.vnet.ibm.com>
	 <661de9470709250002u73c1089dx94870586ce23b5b5@mail.gmail.com>
	 <46F8C09F.4050707@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 25 Sep 2007 09:58:53 -0400
Message-Id: <1190728734.5036.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 13:32 +0530, Kamalesh Babulal wrote:
> Balbir Singh wrote:
> > On 9/25/07, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> >> Exactly same call trace is produced over IA64 Madison (up to 9M cache) with 8 cpu's.
> >> --
> > 
> > Hi, Kamalesh,
> > 
> > Could you please reproduce the problem or share the steps to reproduce
> > the problem?
> > 
> > Thanks,
> > Balbir
> > -
> 
> Hi Balbir,
> 
> Yes, i am able to reproduce the problem. The problem can be reproduced
> using the ltprunall.
> 

I see the problem just trying to boot.  I have yet to successfully boot
23-rc7-mm1 on my platform.  [But, I'll try Ingo's dev tree real soon
now...]

Lee

