Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZGLO5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZGLO5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 10:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZGLO51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 10:57:27 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:37083 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZGLO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 10:57:26 -0400
Date: Sun, 12 Jul 2009 10:57:02 -0400
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090712145702.GA4703@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
References: <20090625220452.GF5540@const.famille.thibault.fr> <20090630063454.GI1351@ucw.cz> <20090701221904.GA4431@const> <20090708093516.GE24385@elf.ucw.cz> <20090708094219.GD5451@const.eduroam-ext.univ-nantes.prive> <20090712103133.GE2033@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090712103133.GE2033@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Sun 12 Jul 2009 12:31:34 +0200, a écrit :
> On Wed 2009-07-08 11:42:19, Samuel Thibault wrote:
> > Pavel Machek, le Wed 08 Jul 2009 11:35:16 +0200, a écrit :
> > > On Thu 2009-07-02 00:19:04, Samuel Thibault wrote:
> > > > Pavel Machek, le Tue 30 Jun 2009 08:34:54 +0200, a écrit :
> > > > > Please keep a11y and similar madness far from kernel.
> > > > 
> > > > What do you qualify as "madness" precisely?  Could you explain why you
> > > > are using such extreme word?
> > > 
> > > If the word is so long that you have to write number of its letters
> > > inside... then you are using wrong word.
> > 
> > Unfortunately that's the word.  If the very notion of accessibility was
> > realized by mankind earlier maybe we'd have had a shorter word for it.
> 
> "speech" would seem good enough substitute.

For the speech case. Then you could have braille, speech recognition,
etc.

> > > > > BTW... from 486+, cpus are fast enough for speech synthesis. Why not
> > > > > doing it in software, viewing hw synthetisers as 'flite coprocessors'?
> > > > 
> > > > At least because flite is very far from proprietary hardware
> > > > synthesizers in terms of quality.
> > > 
> > > Well... but for reading boot messages, it might be adequate, right?
> > 
> > I'd actually say it's particularly not adequate.  Try to feed your dmesg
> > to a speech synthesizer and try to understand it.
> 
> Do you really expect blind people to do kernel hacking?

They do.  Why shouldn't they be able to?

> > > You know... "normal" consoles (such as vt) do fail sometimes, too.
> > 
> > Yes, and in such case sighted and blind users are on equal basis.  In
> > that case there is no need for a particular support for blind people.
> 
> You know, we do not translate kernel messages into other languages,
> either. So maybe we should make sure that Linux machines can be used
> without reading dmesg, and just do it from initrd?

People can learn english. Blind people can't learn seeing.

> After all, most distributions _already_ put splashscreens on, so 99%
> of people do not see kernel messages, either...

Blindness is orthogonal to that 99%.

Samuel
