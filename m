Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZFNJJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZFNJJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 05:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbZFNJJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 05:09:29 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:35361 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750770AbZFNJJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 05:09:28 -0400
Date: Sun, 14 Jun 2009 11:06:21 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, swetland@google.com, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090614090621.GD22856@game.jcrosoft.org>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611123852.GM795@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Ovh-Tracer-Id: 13710364641485237171
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.500074/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> For the most part, the answer is no.  People concentrate on their own
> areas, and won't look at someone with a new class of platforms (eg,
> the STMP or W90x900 stuff).
Personnaly I do the effort to review other people stuff as I've to do on
U-Boot for my Maintainer staff specially when I've to review them also for
U-Boot as example the Nomadidk stuff
> 
> I'd absolutely love it if the review load could be shared, but for the
> most part it just doesn't happen.  Everyone's far too busy with their
> own stuff to help out (and that's a reason that they'll give if tackled
> head on about it.)
> 
> As I've already said, akpm tried to setup a mutual review between
> several ARM folk, but as far as I'm aware, it has so far been 
> unsuccessful (exactly why I don't know.)
> 
> So to somehow level an accusation at me that I'm tightly controlling this
> stuff is way off the mark.  I've been trying to get greater participation
> but it's just not happening.
> 
> > Or, alternatively, experiment with tools that could potentially make
> > you more efficient (patchwork has worked wonders for me).
> 
> If patchwork can replace what my patch system does for me (which is
> basically to help ensure that patches don't get lost which need
> applying - that's different from logging every single patch) then
> I'll gladly look at it.  It will mean that some of the sanity checks
> on the patch content, which happen automatically with the patch system,
> will need to be done manually.
> 
> If patchwork just gathers up every patch which has ever been seen on
> a mailing list, then stuff will get lost at a higher rate than today
> and it will have a negative impact.
I've try the patchwork system for some month and It's for really the same as
your patch system but if you configured it correctly it will simplify your
life. I've start to develop 2 or 3 scripts that I use with mutt to change the
state on a patch and co, to have something near your patch system

Best Regards,
J.
