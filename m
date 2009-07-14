Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbZGNJww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbZGNJww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbZGNJww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:52:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44514 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbZGNJwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:52:51 -0400
Date: Tue, 14 Jul 2009 11:52:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090714095243.GE2076@elf.ucw.cz>
References: <20090625220452.GF5540@const.famille.thibault.fr> <20090630063454.GI1351@ucw.cz> <20090701221904.GA4431@const> <20090708093516.GE24385@elf.ucw.cz> <20090708094219.GD5451@const.eduroam-ext.univ-nantes.prive> <20090712103133.GE2033@elf.ucw.cz> <20090712145702.GA4703@const>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090712145702.GA4703@const>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > If the word is so long that you have to write number of its letters
> > > > inside... then you are using wrong word.
> > > 
> > > Unfortunately that's the word.  If the very notion of accessibility was
> > > realized by mankind earlier maybe we'd have had a shorter word for it.
> > 
> > "speech" would seem good enough substitute.
> 
> For the speech case. Then you could have braille, speech recognition,
> etc.

Well, but maybe braile and speech recognition _don't_ belong together? 

> > > I'd actually say it's particularly not adequate.  Try to feed your dmesg
> > > to a speech synthesizer and try to understand it.
> > 
> > Do you really expect blind people to do kernel hacking?
> 
> They do.  Why shouldn't they be able to?
...
> > > > You know... "normal" consoles (such as vt) do fail sometimes, too.
> > > 
> > > Yes, and in such case sighted and blind users are on equal basis.  In
> > > that case there is no need for a particular support for blind people.
> > 
> > You know, we do not translate kernel messages into other languages,
> > either. So maybe we should make sure that Linux machines can be used
> > without reading dmesg, and just do it from initrd?
> 
> People can learn english. Blind people can't learn seeing.

I guess for such case, serial console to machine with running system
(with speech synthesis/braille/etc) is the way to go. Anything else
just will not work early enough.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
