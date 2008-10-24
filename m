Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYJXSwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYJXSwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYJXSvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:51:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47535 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbYJXSvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:51:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Current suspend issues on Lenovo X200 (w/ Intel graphics)
Date: Fri, 24 Oct 2008 20:56:22 +0200
User-Agent: KMail/1.9.9
Cc: Andres Freund <andres@anarazel.de>,
       "Nico -telmich- Schottelius" <nico-linux-next@schottelius.org>,
       Nigel Cunningham <ncunningham@crca.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <200810242030.54273.rjw@sisk.pl> <20081024184727.GJ22217@kernel.dk>
In-Reply-To: <20081024184727.GJ22217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810242056.23272.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 24 of October 2008, Jens Axboe wrote:
> On Fri, Oct 24 2008, Rafael J. Wysocki wrote:
> > On Friday, 24 of October 2008, Jens Axboe wrote:
> > > On Fri, Oct 24 2008, Andres Freund wrote:
> > > > On Friday 24 October 2008 15:01:31 Nico -telmich- Schottelius wrote:
> > > > > > > Chipset Mobile Intel® GM45 Express Chipset found
> > > > > > This is going to be interesting. :-)
> > > > > > Nico, if the system is 64-bit, I'd recommend trying .28-rc1.
> > > > > Yes, I'm on amd64;
> > > > > As seen on my other post: xorg does not run on .28-rc1
> > > > The kernel has a fix for memory management for GM45 cards since 2.6.28-rc1 
> > > > which require a newer driver, so trying this may be benifical (patch in reply 
> > > > to your first post).
> > > 
> > > No go, same for me on x60 on ubuntu 8.10-rc1.
> > 
> > Is this a regression on your box?
> 
> Yes, definitely.

Which kernel did work?
