Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbXKTUAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbXKTUAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbXKTUAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:00:30 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:3622 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754439AbXKTUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:00:29 -0500
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8, v2.6.22.13, v2.6.21.7
From: Vincent Fortier <vincent.fortier1@ec.gc.ca>
Reply-To: vincent.fortier1@ec.gc.ca
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071119151756.GA25446@elte.hu>
References: <20071119151756.GA25446@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Environnement Canada
Date: Tue, 20 Nov 2007 20:00:06 +0000
Message-Id: <1195588806.7534.3.camel@kayak.wul.qc.ec.gc.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 20 Nov 2007 20:00:07.0545 (UTC) FILETIME=[F2F4A690:01C82BAF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 16:17 +0100, Ingo Molnar wrote:
> By popular demand, here is release -v24 of the CFS scheduler patch.
> 
> It is a full backport of the latest & greatest scheduler code to 
> v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7. The patches can be 
> downloaded from the usual place:
> 
>     http://people.redhat.com/mingo/cfs-scheduler/
> 
> There's tons of changes since v22 was released:
> 
>     36 files changed, 2359 insertions(+), 1082 deletions(-)
> 
> that's 187 individual commits from 32 authors.
> 
> So even if CFS v22 worked well for you, please try this release too and 
> report regressions (if any).
> 
Hi Ingo,

Tested latest v24 patch against 686 & x86_64 and it runs smoothly, at
least as well as previous v22 release.

As always, Thnx very much for this backport.

- vin


