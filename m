Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbZELMlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbZELMlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 08:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbZELMlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 08:41:15 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:1946 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbZELMlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 08:41:14 -0400
Date: Tue, 12 May 2009 08:38:26 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, p0g0@madwifi-project.org,
       madwifi-project@venema.h4ckr.net, Cliff.Holden@atheros.com,
       mb@bu3sch.de, nbd@openwrt.org, mickflemm@gmail.com, proski@gnu.org,
       juhosg@openwrt.org, linux-kernel@vger.kernel.org
Subject: Re: [madwifi-project] Death to MadWifi!
Message-ID: <20090512123826.GA19410@hash.localnet>
References: <43e72e890905111627r54fd4fa4r26d9511c1fd625a2@mail.gmail.com> <4A0908AB.1070606@madwifi-project.org> <4A0908AB.1070606@madwifi-project.org> <43e72e890905112332j3e32fb8q942fb75f882b2384@mail.gmail.com> <200905121114.24355.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905121114.24355.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 11:14:21AM +0200, Frans Pop wrote:
> The way FOSS normally works is that one variant of alternative software 
> will gradually die a natural death once a clear superior is established. 
> There should be no need for members of rival projects to try to actively 
> kill eachother off (the rival project that is, not its members).

I agree, free software is about choice, and I really don't have a problem
with people using madwifi if it works for them, especially as it is now
open source (*not* the case when ath5k was born, and it would probably
still be closed source today without the work of Luis and Atheros, and
Jiri and Nick).

Of course, it reduces our pool of testers when people use madwifi, and I 
do have a vested interest in seeing ath5k succeed.  But ath5k is still
a young driver and maturing, so for now, madwifi may work better for some.
For me, ease of compilation was enough; I switched the day it was merged
into mainline even though it didn't work at all on my hardware at the time.
Now, it is quite stable here and I don't miss madwifi at all.

For what it is worth, I find it rather counter-productive when people on
irc suggest using ath5k to solve every madwifi problem, for example, for
AP mode, which clearly isn't enabled in even 2.6.30 and has bugs with the
TIM in the wireless-testing kernel[1].  That sort of thing just leads to
pissed off users.  Then said users go rant in bugzilla, claiming the kernel
developers are in league with the illuminati to steal their working setup
and rain misery down upon them[2].

Anyway, it is shameful to criticize Luis' intentions, who has done
nothing but work to get Atheros invested in the free software community;
I say that as someone with zero ties to Atheros other than having their
hardware.  Just look at the tree now, there are three fully open source
Atheros drivers, one of which was written entirely on Atheros' dime.
 
> P.S. This is the only post I've seen from this thread as apparently it 
> started somewhere other than LKML.

Same here, well, hopefully the thread will at least result in more
ath5k bug reports.

[1] I have a patch.
[2] We aren't (officially, at least).

-- 
Bob Copeland %% www.bobcopeland.com

