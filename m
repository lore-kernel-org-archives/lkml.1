Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbYG3JG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbYG3JG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760811AbYG3JGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:06:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56295 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760447AbYG3JGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:06:05 -0400
Date: Wed, 30 Jul 2008 11:05:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>, Greg KH <gregkh@suse.de>
Cc: Frederik Deweerdt <deweerdt@free.fr>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	00000002
Message-ID: <20080730090549.GA26904@elte.hu>
References: <20080725095317.GA12636@skywalker> <20080728222643.GA6339@slug> <1217305335.5553.3.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217305335.5553.3.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2008-07-29 at 00:26 +0200, Frederik Deweerdt wrote:
> > Hello  Aneesh,
> > 
> > On Fri, Jul 25, 2008 at 03:23:17PM +0530, Aneesh Kumar K.V wrote:
> > > [  163.378265] BUG: unable to handle kernel NULL pointer dereference at 00000002
> > > [  163.378276] IP: [<c0124933>] sched_power_savings_store+0x13/0x70
> > 
> > Does the attached patch solve the problem?
> 
> Patch seems to have missed the boat for rc1 too.

Greg?

	Ingo
