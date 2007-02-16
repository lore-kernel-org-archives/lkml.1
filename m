Return-Path: <linux-kernel-owner+w=401wt.eu-S1945942AbXBPPfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945942AbXBPPfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945943AbXBPPfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:35:12 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:34781 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945942AbXBPPfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:35:09 -0500
Date: Fri, 16 Feb 2007 10:34:35 -0500
To: Josh Boyer <jwboyer@gmail.com>
Cc: v j <vj.linux@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070216153435.GQ7584@csclub.uwaterloo.ca>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <20070215061149.GE15654@redhat.com> <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com> <20070215165339.GB5285@thunk.org> <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com> <625fc13d0702151041w3621b18aw299133164db1bde4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625fc13d0702151041w3621b18aw299133164db1bde4@mail.gmail.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 12:41:45PM -0600, Josh Boyer wrote:
> You are not blocked by this.  Your largest gripe seems to be the fact
> that the community does not want to endorse proprietary modules.  For
> _your_ use, with advice from _your_ legal team, with _your_ company
> assuming any risk, you can certainly continue to use Linux because the
> very people you're whining at _did_ contribute the code and provide it
> under an Open Source license.  However, I would not want to be in your
> position should your company choose to go that avenue and a lawsuit
> occurred.

How could the community endorse closed source drivers?  The community
can't actually get a consensus on whether the GPL allows such things or
not and under what circumstances.  Linux uses the GPLv2 and whatever it
says, and whatever a court decides that means in a given lawsuit is
really what matters.  Even if 1000 people that were major contributers
to the linux kernel were to say "we think binary closed source drivers
are OK" doesn't mean that there isn't 1 other person who doesn't think
so, and wrote some part of what you decided to use with a closed source
driver and then decides to sue you and then you are back to what the
courts say in that particular case in whatever juristiction it takes
place in.  Maybe the opinion of those 1000 developers makes a difference
to the judge, maybe it doesn't.  That is all tha matters.  Whatever is
put into the kernel to make life inconvinient for closed source drivers
doesn't matter, since you could always remove that from your particular
copy of the kernel that you distribute.  The only thing that matters is
what happens if you do something that some developer believes violates
the GPLv2 and decides to sue you over violating the license of his
particular piece of the code.

If you don't want to deal with that, then don't use GPL'd code.  Go use
BSD or some commercial option that only wants money and the promise that
you not share their code with others.

--
Len Sorensen
