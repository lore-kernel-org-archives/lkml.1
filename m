Return-Path: <linux-kernel-owner+w=401wt.eu-S1763064AbXGaOrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763064AbXGaOrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760321AbXGaOrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:47:00 -0400
Received: from colo.lackof.org ([198.49.126.79]:40928 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759684AbXGaOq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:46:59 -0400
Date: Tue, 31 Jul 2007 08:46:51 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Valerie Henson <val@nmt.edu>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, tulip-users@lists.sourceforge.net,
       Grant Grundler <grundler@parisc-linux.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [TULIP] Need new maintainer
Message-ID: <20070731144651.GA1548@colo.lackof.org>
References: <20070730190412.GA16182@rainbow> <20070730193158.GA13808@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730193158.GA13808@fattire.cabal.ca>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 03:31:58PM -0400, Kyle McMartin wrote:
> On Mon, Jul 30, 2007 at 01:04:13PM -0600, Valerie Henson wrote:
> > The Tulip network driver needs a new maintainer!  I no longer have
> > time to maintain the Tulip network driver and I'm stepping down.  Jeff
> > Garzik would be happy to get volunteers.

Val!
I'm sorry to see you have to drop this one...C'est la Vie.

> Since I already take care of a major consumer of these devices (parisc,
> which pretty much all have tulip) I'm willing to take care of this.
> Alternately, Grant is probably willing.

Yeah, I am willing and able to maintain tulip as well.

Either way, parisc and some mips64 folks are stuck with tulip since
that's what is "embedded" on the motherboard. So it would make sense
for someone from either camp to maintain it.

Thanks to David Lang for the offer of 4-port Dlink Tulip card.
HP has two types of 4-port tulip cards (64-bit/33Mhz and 32-bit/33Mhz)
that I gave to Val...so whoever picks up the maintainership can
probably (eventually) get those from Val.

thanks,
grant
