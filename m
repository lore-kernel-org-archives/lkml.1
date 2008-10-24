Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYJXSD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYJXSD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYJXSDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:03:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34670 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYJXSDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:03:50 -0400
Date: Fri, 24 Oct 2008 20:02:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andres Freund <andres@anarazel.de>
Cc: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham@crca.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Current suspend issues on Lenovo X200 (w/ Intel graphics)
Message-ID: <20081024180248.GH22217@kernel.dk>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <200810240911.05193.rjw@sisk.pl> <20081024130130.GA5816@denkbrett.schottelius.org> <200810241630.52740.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810241630.52740.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24 2008, Andres Freund wrote:
> On Friday 24 October 2008 15:01:31 Nico -telmich- Schottelius wrote:
> > > > Chipset Mobile Intel® GM45 Express Chipset found
> > > This is going to be interesting. :-)
> > > Nico, if the system is 64-bit, I'd recommend trying .28-rc1.
> > Yes, I'm on amd64;
> > As seen on my other post: xorg does not run on .28-rc1
> The kernel has a fix for memory management for GM45 cards since 2.6.28-rc1 
> which require a newer driver, so trying this may be benifical (patch in reply 
> to your first post).

No go, same for me on x60 on ubuntu 8.10-rc1.

-- 
Jens Axboe

