Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZGLKbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZGLKbu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 06:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZGLKbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 06:31:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56988 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZGLKbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 06:31:43 -0400
Date: Sun, 12 Jul 2009 12:31:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] accessibility, speakup, speech synthesis & /sys
Message-ID: <20090712103133.GE2033@elf.ucw.cz>
References: <20090625220452.GF5540@const.famille.thibault.fr> <20090630063454.GI1351@ucw.cz> <20090701221904.GA4431@const> <20090708093516.GE24385@elf.ucw.cz> <20090708094219.GD5451@const.eduroam-ext.univ-nantes.prive>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090708094219.GD5451@const.eduroam-ext.univ-nantes.prive>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-08 11:42:19, Samuel Thibault wrote:
> Pavel Machek, le Wed 08 Jul 2009 11:35:16 +0200, a écrit :
> > On Thu 2009-07-02 00:19:04, Samuel Thibault wrote:
> > > Pavel Machek, le Tue 30 Jun 2009 08:34:54 +0200, a écrit :
> > > > Please keep a11y and similar madness far from kernel.
> > > 
> > > What do you qualify as "madness" precisely?  Could you explain why you
> > > are using such extreme word?
> > 
> > If the word is so long that you have to write number of its letters
> > inside... then you are using wrong word.
> 
> Unfortunately that's the word.  If the very notion of accessibility was
> realized by mankind earlier maybe we'd have had a shorter word for it.

"speech" would seem good enough substitute.

> > > > BTW... from 486+, cpus are fast enough for speech synthesis. Why not
> > > > doing it in software, viewing hw synthetisers as 'flite coprocessors'?
> > > 
> > > At least because flite is very far from proprietary hardware
> > > synthesizers in terms of quality.
> > 
> > Well... but for reading boot messages, it might be adequate, right?
> 
> I'd actually say it's particularly not adequate.  Try to feed your dmesg
> to a speech synthesizer and try to understand it.

Do you really expect blind people to do kernel hacking?

> > You know... "normal" consoles (such as vt) do fail sometimes, too.
> 
> Yes, and in such case sighted and blind users are on equal basis.  In
> that case there is no need for a particular support for blind people.

You know, we do not translate kernel messages into other languages,
either. So maybe we should make sure that Linux machines can be used
without reading dmesg, and just do it from initrd?

After all, most distributions _already_ put splashscreens on, so 99%
of people do not see kernel messages, either...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
