Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZHQPPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZHQPPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 11:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZHQPPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 11:15:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47362 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425AbZHQPPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 11:15:04 -0400
Date: Mon, 17 Aug 2009 17:14:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for
	vbus_driver objects
Message-ID: <20090817151449.GA19384@elte.hu>
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A87C3B9.2040206@redhat.com> <4A896648.9040707@gmail.com> <4A897057.2050504@redhat.com> <4A8972C3.30202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8972C3.30202@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <gregory.haskins@gmail.com> wrote:

> Avi Kivity wrote:
> > On 08/17/2009 05:16 PM, Gregory Haskins wrote:
> >>> My opinion is that this is a duplication of effort and we'd be better
> >>> off if everyone contributed to enhancing virtio, which already has
> >>> widely deployed guest drivers and non-Linux guest support.
> >>>
> >>> It may have merit if it is proven that it is technically superior to
> >>> virtio (and I don't mean some benchmark in some point in time; I mean
> >>> design wise).  So far I haven't seen any indications that it is.
> >>>
> >>>      
> >>
> >> The design is very different, so hopefully I can start to convince you
> >> why it might be interesting.
> >>    
> > 
> > We've been through this before I believe.  If you can point out 
> > specific differences that make venet outperform virtio-net I'll 
> > be glad to hear (and steal) them though.
> 
> You sure know how to convince someone to collaborate with you, eh?
> 
> Unforunately, i've answered that question numerous times, but it 
> apparently falls on deaf ears.

I'm trying to find the relevant discussion. The link you gave in the 
previous mail:

  http://lkml.org/lkml/2009/4/21/408

does not offer any design analysis of vbus versus virtio, and why 
the only fix to virtio is vbus. It offers a comparison and a blanket 
statement that vbus is superior but no arguments.

(If you've already explained in a past thread then please give me an 
URL to that reply if possible, or forward me that prior reply. 
Thanks!)

	Ingo
