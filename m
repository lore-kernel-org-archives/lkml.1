Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZGNMpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZGNMpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 08:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZGNMpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 08:45:06 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:57511 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZGNMpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 08:45:05 -0400
Date: Tue, 14 Jul 2009 08:44:59 -0400
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090714124459.GA5034@const.linuxsymposium.org>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <20090625220452.GF5540@const.famille.thibault.fr> <20090630063454.GI1351@ucw.cz> <20090701221904.GA4431@const> <20090708093516.GE24385@elf.ucw.cz> <20090708094219.GD5451@const.eduroam-ext.univ-nantes.prive> <20090712103133.GE2033@elf.ucw.cz> <20090712145702.GA4703@const> <20090714095243.GE2076@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090714095243.GE2076@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Tue 14 Jul 2009 11:52:43 +0200, a écrit :
> > > > > If the word is so long that you have to write number of its letters
> > > > > inside... then you are using wrong word.
> > > > 
> > > > Unfortunately that's the word.  If the very notion of accessibility was
> > > > realized by mankind earlier maybe we'd have had a shorter word for it.
> > > 
> > > "speech" would seem good enough substitute.
> > 
> > For the speech case. Then you could have braille, speech recognition,
> > etc.
> 
> Well, but maybe braile and speech recognition _don't_ belong together? 

They are often used together.

> > > > I'd actually say it's particularly not adequate.  Try to feed your dmesg
> > > > to a speech synthesizer and try to understand it.
> > > 
> > > Do you really expect blind people to do kernel hacking?
> > 
> > They do.  Why shouldn't they be able to?
> ...

Yes, "..."

I'm amazed that you could think that blind people shouldn't do kernel
hacking?  Why shouldn't they?  Actually they could be even better at
it that sighted people, precisely because kernel stuff is mostly about
stuff that you can't see.

> > > > > You know... "normal" consoles (such as vt) do fail sometimes, too.
> > > > 
> > > > Yes, and in such case sighted and blind users are on equal basis.  In
> > > > that case there is no need for a particular support for blind people.
> > > 
> > > You know, we do not translate kernel messages into other languages,
> > > either. So maybe we should make sure that Linux machines can be used
> > > without reading dmesg, and just do it from initrd?
> > 
> > People can learn english. Blind people can't learn seeing.
> 
> I guess for such case, serial console to machine with running system
> (with speech synthesis/braille/etc) is the way to go. Anything else
> just will not work early enough.

Yes, and so in such extreme case there is no need for particular
support.  But the "initrd is hosed" case is not so rare.

Samuel
