Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZG0XPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZG0XPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 19:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZG0XPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 19:15:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40047 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbZG0XPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 19:15:06 -0400
Date: Tue, 28 Jul 2009 01:14:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC: touchscreen driver
Message-ID: <20090727231459.GD7142@elf.ucw.cz>
References: <20090714094629.GB2076@elf.ucw.cz> <d6200be20907141507s39b54cccq9f0cedc325d3a203@mail.gmail.com> <20090714221638.GA6512@elf.ucw.cz> <d6200be20907141545k2b40b790x1af853b89517891c@mail.gmail.com> <20090719212330.GI26511@elf.ucw.cz> <d6200be20907192043w3f1aa2abvd0125163e6f5519c@mail.gmail.com> <20090721101103.GD4133@elf.ucw.cz> <d6200be20907211812l47012c00i1fc7de53db97d702@mail.gmail.com> <20090723212506.GS28158@elf.ucw.cz> <d6200be20907231711hdf8173avea686b63db157b93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20907231711hdf8173avea686b63db157b93@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> git fetch git://android.git.kernel.org/kernel/experimental.git
> >> android-msm-2.6.30-rc2-test
> >> git cherry-pick 9f89902daf7a3c6fdd6b0c7494f3cc82d5e09217
> >
> > So I spent 10 minutes downloading patch you could have inlined... only
> > to find out that review already pointed nosync issue (and I fixed swap
> > independetly)...
> 
> Sorry, I thought it was clear what it contained.

Well, I guess I lost that in the mailflood.

> I'm a little confused why you did not already have this though. This
> is the same branch I pushed specifically so you could get at it a
> month ago, and you said you got it booting back then.

I already got the tree (thanks!) but I did not know that I had it, so
I ended up downloading another copy...

BTW... would you have 2.6.31-rcX (or linux-next?) working on dream by chance?

> >> That way you will hopefully not add question marks to my name.
> >
> > ...and I still don't know what your name is. My terminal displays "Arve
> > Hj#???nev##g <arve@android.com>" :-(.
> 
> That does not look right. It displays correctly for me in the mailing
> list archives:
> http://lkml.org/lkml/2009/7/21/496
> 
> gitk also works for me. git log only works if you are using a utf8
> terminal (or have set the character set in your gitconfig).

Apparently my terminals don't speak utf8. (Which is no wonder, I had
to fall back to xterm when gnome-terminal stopped working). Web
browser displays your name correctly, so I now know what it is, and I
can even paste it (Arve Hjřnnevĺg). I wonder if it gets through the
mail system undamaged. (If not, is there acceptable transcription of
your name to us/ascii?)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
