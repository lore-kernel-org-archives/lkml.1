Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbZDGOBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbZDGOBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbZDGOAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:00:50 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57964 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbZDGOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:00:48 -0400
Date: Tue, 7 Apr 2009 09:53:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Michael Buesch <mb@bu3sch.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: ath9k becon loss messages
Message-ID: <20090407135359.GA28289@tuxdriver.com>
References: <1238923439.4120.9.camel@localhost.localdomain> <200904061217.31134.mb@bu3sch.de> <87tz52xepy.fsf@litku.valot.fi> <200904061251.10965.helmut.schaa@gmail.com> <da94abde0904060405k280b3094jc20d0f7a4e6e759d@mail.gmail.com> <87iqlhdd3z.fsf@litku.valot.fi> <20090406180042.GD10842@tuxdriver.com> <87fxglhuuc.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fxglhuuc.fsf@litku.valot.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 08:54:35AM +0300, Kalle Valo wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:
> 
> > On Mon, Apr 06, 2009 at 06:18:56PM +0300, Kalle Valo wrote:
> >
> >> When I'm able to implement the proper fix, I think it should first have
> >> proper testing in wireles-testing before pushing it to mainline. So
> >> maybe the proper fix is 2.6.31 material, just to be on the safe side
> >> here.
> >> 
> >> John, what do you think?
> >
> > It depends on what the proper fix looks like, but basically anything
> > posted in the last week and thereafter is already 2.6.31 material
> > unless it is a specific bug fix for what is already in Linus' kernel.
> 
> Ok, that settles it then. Because this bug has been in mac80211 for ages
> we can wait for 2.6.31.
> 
> But do you take Michael's patch[1] for disabling the "beacon loss"
> message for 2.6.30? I think we should have it in 2.6.30, otherwise we
> will get quite a lot of bug reports. Do you want me to resend it?
> 
> [1] http://marc.info/?l=linux-kernel&m=123892431619630&w=2

I'll make a note of it.

I took a couple of days off last week and have been poking at other
things, so I'm a bit behind on the merging.  If you don't see it in
another week or so then poke me again?

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
