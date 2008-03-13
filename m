Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbYCMWuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbYCMWuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYCMWun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:50:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40378 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYCMWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:50:42 -0400
Date: Thu, 13 Mar 2008 22:50:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux+glibc memory allocator, poor performance
Message-ID: <20080313225040.GO27894@ZenIV.linux.org.uk>
References: <998d0e4a0803121309s125dddbao801e53e44296a4d6@mail.gmail.com> <20080312211219.GL27894@ZenIV.linux.org.uk> <47D8C25A.8020708@davidnewall.com> <1205388732.4797.30.camel@marge.simson.net> <47D8C813.6020201@davidnewall.com> <84144f020803130210r1c7e8e11k7aedd3c60e7f5d0a@mail.gmail.com> <20080313121048.5b52b28b@the-village.bc.nu> <84144f020803130548o76f80fedm378f82e95c189ce2@mail.gmail.com> <47D98311.2040302@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D98311.2040302@davidnewall.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 06:10:01AM +1030, David Newall wrote:
> Pekka Enberg wrote:
> > Hi Alan,
> >
> > On Thu, Mar 13, 2008 at 2:10 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >   
> >>  Politeness is a good thing this list needs more of.
> >>     
> >
> > Do you honestly think we should be polite to people trolling on the
> > LKML?
> 
> I do.  It's obvious.  Rudeness detracts (and reflects poorly on one's
> parents.)  Good manners cost nothing.  I might also point out that it
> was bad manners, not any alleged trolling, which caused this sad
> discussion.

"Deliberate insult" would describe the original posting more accurately.
Whether you prefer to look at it as a show of bad manners or as trolling
is a matter of perspective; arguably it had been both.

> Don't be rude; rather say nothing.

Request duly noted and denied.  For the record: condescending twits of that
variety ("I can't be arsed to look at code I'm commenting on; here's my
valuable insight that is obviously beyond the mental capacity of anybody
here") can expect a harsh reply, whoever they are.  I'm yet to see l-k
regulars treating newbies that way, BTW, despite the much decried lack of
politeness.

Since you are postulating social norms, here's one you seem to have overlooked:
one who comments on code or design, be it review, suggestions of changes/
improvements, etc., ought to read the thing he is commenting on.  Whoever
it is and wherever the code in question might be.  And yes, it applies to
kernel hackers commenting on newbies' patches to the same extent as to
completely unknown folks commenting on the kernel, etc.

Breaking that rule and being caught at that is one hell of a way to earn
yourself a lousy reputation.  Combine that with arrogance and... well,
there's a term for what you become: target practice.
