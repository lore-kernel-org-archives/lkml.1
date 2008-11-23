Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYKWR07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYKWR07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 12:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYKWR0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 12:26:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57042 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750987AbYKWR0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 12:26:24 -0500
Date: Sun, 23 Nov 2008 13:30:32 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Shem Multinymous <multinymous@gmail.com>,
       "J.R. Mauro" <jrm8005@gmail.com>, tpctl-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [Tpctl-users] Inclusion of tp_smapi module into kernel?
Message-ID: <20081123123032.GA7310@ucw.cz>
References: <200811171455.50039.hanno@hboeck.de> <49219DF5.5040404@zytor.com> <3aaafc130811170913o761ce43fg3a2738586ebd2396@mail.gmail.com> <41840b750811171035w63c794aepaa273bc55fbaf2@mail.gmail.com> <4921C425.7020806@zytor.com> <20081117202704.GG14523@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117202704.GG14523@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-11-17 15:27:04, Theodore Tso wrote:
> On Mon, Nov 17, 2008 at 11:21:09AM -0800, H. Peter Anvin wrote:
> >> We've discussed that in private at the time, and recently on LKML too.
> >> In summary:
> >> I'm fine with that, and so is everybody I talked to (including Linus),
> >> except Greg KH who vetoed it since he believes the code is irrevocably
> >> and contagiously evil.
> >>
> >
> > Signed-off-by is about copyright, it's not a review issue.  It means "I  
> > certify that I know that the author had the rights to submit this code."  
> >   Code quality is important but separate.
> 
> Indeed; so what were Greg KH's complaints, specifically?  Were they a
> code review issue or was just complaining about the anonymity issue?

Anonymity issue.

I'm working on similar driver for HP machines, and it would be great
 to be able to test that on my thinkpad, so I'm willing to clean up
 the code if required, maintain it, whatever...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
