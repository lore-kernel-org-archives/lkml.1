Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZKCP3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZKCP3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZKCP3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:29:53 -0500
Received: from senator.holtmann.net ([87.106.208.187]:57823 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZKCP3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:29:52 -0500
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <1257238623.28469.47.camel@johannes.local>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	 <20091102.224957.32364226.davem@davemloft.net>
	 <20091103065238.GE3212@core.coreip.homeip.net>
	 <1257232587.3420.55.camel@localhost.localdomain>
	 <1257234299.28469.25.camel@johannes.local>
	 <20091103082201.GG3212@core.coreip.homeip.net>
	 <1257237061.28469.43.camel@johannes.local>
	 <20091103084744.GH3212@core.coreip.homeip.net>
	 <1257238623.28469.47.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 00:29:47 +0900
Message-Id: <1257262187.3420.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> > > I just think that it's a matter of courtesy that should be independent
> > > from the release cycle to ask the author/maintainer by default, not as a
> > > second thought ("unless [...] have other solution"). You can always CC
> > > Linus and ask him to revert if you don't get a response.
> > > 
> > > What's wrong with that? It doesn't actually delay the action, but it
> > > makes the discussion much more friendly and cooperative instead of
> > > giving the author and maintainer the feeling that their opinion only
> > > matters as a second thought.
> > > 
> > 
> > I think you are reading too much into who was addressed directly and who
> > was "only" CCed... 
> 
> Maybe. But it seems to be happening pretty often recently that people
> first ask for a revert and then for a fix, ignoring any thought that
> might have gone into a particular commit...

I have to agree here. It happens why too often lately. And this needs to
stop. Otherwise why bother with subsystem maintainers? Just send
everything to Linus directly and have him to review every line of code.

Dmitry, this is not against you, but the proper way would have been to
just mail linux-wireless about it and you would have gotten the same
response to it than you got by including Linus and LKML. This blind CC
to LKML is not helpful. It starts confusion and just increases the load
on that mailing list. There is a reason why the MAINTAINERS file now
contains the mailing list contacts, please use them and not try to jump
over two subsystem maintainers to get something fixed. Neither Linus nor
Dave are the right people to comment on your bug.

Regards

Marcel


