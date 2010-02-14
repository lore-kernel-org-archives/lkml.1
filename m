Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab0BNRN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:13:57 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51607 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0BNRN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:13:56 -0500
Date: Sun, 14 Feb 2010 18:13:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100214171327.GF1578@ucw.cz>
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu> <20100213091748.276821e1@hyperion.delvare> <4B767810.5020707@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B767810.5020707@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-02-13 10:59:44, Stefan Richter wrote:
> Jean Delvare wrote:
> > On Sat, 13 Feb 2010 00:07:02 +0100, Willy Tarreau wrote:
> >> Gzip is well
> >> defined as a standard, it's even described in an RFC and is present
> >> on almost any system (unix or not) now. Any student who wants to take
> >> a look at the kernel will have access to gunzip, even from an old
> >> Solaris 8 workstation or a Windows XP desktop PC.
> > 
> > Really? I have a Windows XP laptop at hand and it can't read .gz files.
> > If I ask it to try, it tells me I should install WinZip. I also seem to
> > recall that I had to install GNU gzip myself back when I was working on
> > a Solaris workstation (but I might remember badly.)
> 
> As a side note:  7zip, a very popular and Free archiving tool for
> Windows, supports xz since its version 9 which is currently available as
> a beta.  So, WRT the need to get an extra unarchiver, xz is just as
> accessible to Windows users as gz is.

Wow, what a stretch.

There's about milion tools supporting gz for Windows, and many of them
are out of beta... xz is not even supported on my zaurus, and I'll
need to write some emails to get it installed on school servers...

Anyway, gz+xz should be reasonable combination.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
