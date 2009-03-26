Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZCZIAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZCZIAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZCZH7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:59:51 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:21957 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbZCZH7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jRKoXRFVg26Y1b3uo5k6KJMgLXPf8pAn8/xfOgT2BfSS7mwMXQdHqXJccEiRksQv3B
         vgQvItZFNuHZFy8Z7BQqTXwb56GEN4Cynq4zFRL2sfwsZ8mby0TB09Mp5JFfXOfMxneW
         JQATCGo3j9pIag4+cmVUGB7XEafvKnvyBD20k=
Date: Thu, 26 Mar 2009 07:59:41 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, mingo@elte.hu, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090326075941.GC4204@ff.dom.local>
References: <20090325225456.GA3271@ami.dom.local> <20090325.171019.56283101.davem@davemloft.net> <20090326064317.GA4204@ff.dom.local> <20090326.005212.50671100.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326.005212.50671100.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 12:52:12AM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Thu, 26 Mar 2009 06:43:17 +0000
> 
> > On Wed, Mar 25, 2009 at 05:10:19PM -0700, David Miller wrote:
> > > From: Jarek Poplawski <jarkao2@gmail.com>
> > > Date: Wed, 25 Mar 2009 23:54:56 +0100
> > > 
> > > Ingo, in case it isn't completely obvious, it would be
> > > wonderful if you could try Jarek's patch below with your
> > > test case.
> > > 
> > > Thanks!
> > 
> > David, of course testing my patch would be very nice, but I think we
> > should definitely & immediately have this tested already Herbert's
> > revert patch in -stable now. 
> 
> Sure, I'll do that.
> 
> We can toy with this thing during 2.6.30 development.

Or add this to the next -stable after testing.

Jarek P.
