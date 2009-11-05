Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbZKETUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbZKETUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbZKETUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:20:01 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36600 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438AbZKETUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:20:00 -0500
Date: Thu, 5 Nov 2009 20:19:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
	7d930bc33653d5592dc386a76a38f39c2e962344
Message-ID: <20091105191951.GC1392@ucw.cz>
References: <20091103053156.GA3212@core.coreip.homeip.net> <20091102.224957.32364226.davem@davemloft.net> <20091103065238.GE3212@core.coreip.homeip.net> <1257232587.3420.55.camel@localhost.localdomain> <1257234299.28469.25.camel@johannes.local> <20091103082201.GG3212@core.coreip.homeip.net> <1257237061.28469.43.camel@johannes.local> <20091103084744.GH3212@core.coreip.homeip.net> <1257238623.28469.47.camel@johannes.local> <1257262187.3420.73.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257262187.3420.73.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-11-04 00:29:47, Marcel Holtmann wrote:
> Hi Johannes,
> 
> > > > I just think that it's a matter of courtesy that should be independent
> > > > from the release cycle to ask the author/maintainer by default, not as a
> > > > second thought ("unless [...] have other solution"). You can always CC
> > > > Linus and ask him to revert if you don't get a response.
> > > > 
> > > > What's wrong with that? It doesn't actually delay the action, but it
> > > > makes the discussion much more friendly and cooperative instead of
> > > > giving the author and maintainer the feeling that their opinion only
> > > > matters as a second thought.
> > > > 
> > > 
> > > I think you are reading too much into who was addressed directly and who
> > > was "only" CCed... 
> > 
> > Maybe. But it seems to be happening pretty often recently that people
> > first ask for a revert and then for a fix, ignoring any thought that
> > might have gone into a particular commit...
> 
> I have to agree here. It happens why too often lately. And this needs to
> stop. Otherwise why bother with subsystem maintainers? Just send
> everything to Linus directly and have him to review every line of code.
> 
> Dmitry, this is not against you, but the proper way would have been to
> just mail linux-wireless about it and you would have gotten the same
> response to it than you got by including Linus and LKML. This blind CC
> to LKML is not helpful. It starts confusion and just increases the load

Yes, lkml cc *is* helpful, as he's probably not the only one hitting
that problem.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
