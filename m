Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbXKMNKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbXKMNKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 08:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXKMNJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 08:09:59 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:45251 "EHLO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361AbXKMNJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 08:09:57 -0500
Date: Tue, 13 Nov 2007 15:09:53 +0200
From: Tuomo Valkonen <tuomov@iki.fi>
To: Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071113130953.GA16543@jolt.modeemi.cs.tut.fi>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de> <20071112160254.GA31972@jolt.modeemi.cs.tut.fi> <47388F5A.20206@smsglobal.net> <slrnfjh4o1.c8q.tuomov@jolt.modeemi.cs.tut.fi> <20071113132847.555e6c84@astralstorm.puszkin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071113132847.555e6c84@astralstorm.puszkin.org>
X-Archive: encrypt
X-PGP-Fingerprint: 3B2A 89E6 9468 6DC4 FEEF  D6F6 D00C A21E C004 251B
X-PGP-Key: http://modeemi.fi/~tuomov/gpg.txt.asc
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-11-13 13:28 +0100, Radoslaw Szkodzinski wrote:
> The only problem with djb's scheme is that you cannot mirror the software
> unless given permission from the author. No, not even unmodified source.

So? That's why I also call it the "piractic license" and the "apathy
license" -- do what you can get away with without pissing off the
author. In private use you can hardly individually piss of the author,
but powerful distributors can easily do that.

> So, in order to start an X replacement, you have to write an operating
> system around it...

I'm not asking for an X replacement. Despite all of its minor flaws, 
the old X (excluding newer extensions such as Xinerama, Xrender, etc.)
in general is much better than anything the FOSS herd has come up with.
I'm just asking that a small mode-switching part of the graphics driver
were in the kernel (or, preferrably, a micro-kernel service), so that
it was possible to restore the system to a usable state after X crashes,
and generally switch virtual console without demanding applications 
using graphics mode do that. There's already DRI shit in the kernel,
so this is not unprecedented. And yet, things have not improved a bit
from the SVGAlib times. The desktop herd only cares about glitz, not
stability and quality.

> Huh? It is the Microsoft that is the monoculture.

That the FOSS herd apes with passion.

> They supply one true GUI with scarce documentation, a package of bundled
> software and libraries (including C library), one true media system
> (DirectShow) 

They supply all kinds of shit, but it's easier to install third-party
alternatives than on Linux, where The Par^W^Wa few big distributions
have de facto control over easily installable software. The biggest
problem I have with Windows is that applications manage their own
windows, instead of a window manager -- Ion, a shining beacon of
usability all alone in the night, being my last umbilical cord to
FOSS crap. If I could have that in Windows, there would be little
reason at all to use crappy FOSS operating systems. I feat that
the day may come when even that is made practically impossible
by FDO idiocies.

> and one true configuration system - registry. 

Better that than the rendy XML crap and cryptic shell scripts (udev).

> And also an internet browser. 

And the FOSS herd supplies.. Gnomefox. No thanks, I'll stick to Opera,
which I can have on Windows too.

> Footnotes have no place in emails. Theye are not books.

It was not a footnote, but a link, a citation. Links have no place 
inline in emails, messing the flow.

-- 
Tuomo
