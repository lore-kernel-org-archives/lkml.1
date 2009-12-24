Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZLXRn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZLXRn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 12:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZLXRn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 12:43:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:55703 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753003AbZLXRnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 12:43:25 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19mys8R4bBm5pykZolzEYKkFa22pqP/fCAKzM7Gtz
	96VF427EHuN3Ow
Subject: Re: [PATCH 7/6][RFC] sched: unify load_balance{,_newidle}()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       SureshSiddha <suresh.b.siddha@intel.com>,
       "Pallipadi,Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <1261659308.4937.203.camel@laptop>
References: <20091217185021.684424629@chello.nl>
	 <1261581216.4937.150.camel@laptop>
	 <1261629824.10947.13.camel@marge.simson.net>
	 <1261646964.4937.172.camel@laptop>
	 <1261649351.12219.0.camel@marge.simson.net>
	 <1261649811.4937.178.camel@laptop>  <1261659308.4937.203.camel@laptop>
Content-Type: text/plain
Date: Thu, 24 Dec 2009 18:43:16 +0100
Message-Id: <1261676596.9851.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-24 at 13:55 +0100, Peter Zijlstra wrote:
> On Thu, 2009-12-24 at 11:16 +0100, Peter Zijlstra wrote:
> > On Thu, 2009-12-24 at 11:09 +0100, Mike Galbraith wrote:
> > > On Thu, 2009-12-24 at 10:29 +0100, Peter Zijlstra wrote:
> > > 
> > > > Is that with just this patch applied or also with the next one? I
> > > > worried more about the next one.
> > > 
> > > The next one is the troublemaker.
> > 
> > OK, let me re-read all that code with a fresh(er) mind.
> 
> Ok, so how does this work for you?

Yup, all better.  I'll take the full set for a spin, see if anything
else falls out.  (after belt-buster feast and recovery therefrom;)

	-Mike

