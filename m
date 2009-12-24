Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZLXKRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZLXKRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 05:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZLXKRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 05:17:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:54732 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZLXKRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 05:17:22 -0500
Subject: Re: [PATCH 7/6][RFC] sched: unify load_balance{,_newidle}()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       SureshSiddha <suresh.b.siddha@intel.com>,
       "Pallipadi,Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <1261649351.12219.0.camel@marge.simson.net>
References: <20091217185021.684424629@chello.nl>
	 <1261581216.4937.150.camel@laptop>
	 <1261629824.10947.13.camel@marge.simson.net>
	 <1261646964.4937.172.camel@laptop>
	 <1261649351.12219.0.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 11:16:51 +0100
Message-ID: <1261649811.4937.178.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-24 at 11:09 +0100, Mike Galbraith wrote:
> On Thu, 2009-12-24 at 10:29 +0100, Peter Zijlstra wrote:
> 
> > Is that with just this patch applied or also with the next one? I
> > worried more about the next one.
> 
> The next one is the troublemaker.

OK, let me re-read all that code with a fresh(er) mind.

