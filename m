Return-Path: <linux-kernel-owner+w=401wt.eu-S1751585AbZGSV2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbZGSV2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 17:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZGSV2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 17:28:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58980 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZGSV2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 17:28:52 -0400
Date: Sun, 19 Jul 2009 23:27:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090719212721.GJ26511@elf.ucw.cz>
References: <20090625220452.GF5540@const.famille.thibault.fr> <20090630063454.GI1351@ucw.cz> <20090701221904.GA4431@const> <20090708093516.GE24385@elf.ucw.cz> <20090708094219.GD5451@const.eduroam-ext.univ-nantes.prive> <20090712103133.GE2033@elf.ucw.cz> <20090712145702.GA4703@const> <20090714095243.GE2076@elf.ucw.cz> <20090714124459.GA5034@const.linuxsymposium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714124459.GA5034@const.linuxsymposium.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > > I'd actually say it's particularly not adequate.  Try to feed your dmesg
> > > > > to a speech synthesizer and try to understand it.
> > > > 
> > > > Do you really expect blind people to do kernel hacking?
> > > 
> > > They do.  Why shouldn't they be able to?
> > ...
> 
> Yes, "..."
> 
> I'm amazed that you could think that blind people shouldn't do kernel
> hacking?  Why shouldn't they?  Actually they could be even better at
> it that sighted people, precisely because kernel stuff is mostly about
> stuff that you can't see.

They are welcome to do kernel development. And yes, we probably should
support braille devices (that's just another piece of hw).

And we could support hw speech synthetizers, too, if those are simple
drivers.

But I do believe that sw speech synthesis is more important than
obscure hw synthetizers; it is available on way more machines, and
there's no reason why hw synthetizers should be superior.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
