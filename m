Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXCPQVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXCPQVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXCPQVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:21:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38642 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbXCPQVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:21:00 -0400
Date: Fri, 16 Mar 2007 17:19:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch 24/26] Xen-paravirt_ops: Add the Xenbus sysfs and virtual device hotplug driver.
Message-ID: <20070316161948.GE9413@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232529.271605211@goop.org> <20070316084704.GB23174@elte.hu> <20070316161804.GH10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316161804.GH10574@sequoia.sous-sol.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > 
> > > This communicates with the machine control software via a registry 
> > > residing in a controlling virtual machine. This allows dynamic 
> > > creation, destruction and modification of virtual device 
> > > configurations (network devices, block devices and CPUS, to name some 
> > > examples).
> > 
> > should be reviewed by the driver-core folks too i guess?
> 
> Greg has gone through it a couple times.  Any more feedback would be 
> useful.

please indicate any such review feedback (and approval) via 
signed-off-by lines done by that person.

	Ingo
