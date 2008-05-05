Return-Path: <linux-kernel-owner+w=401wt.eu-S1762441AbYEEVNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762441AbYEEVNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760604AbYEEVMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:12:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37876 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758675AbYEEVMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:12:52 -0400
Date: Mon, 5 May 2008 23:13:41 +0200
From: Pavel Machek <pavel@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und: some more code removal
Message-ID: <20080505211341.GA17657@elf.ucw.cz>
References: <20080505200927.GA7273@elf.ucw.cz> <1210018631.4181.29.camel@johannes.berg> <20080505202057.GB7273@elf.ucw.cz> <1210018983.4181.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210018983.4181.33.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Remove some more unneccessary code
> > > > 
> > > > ---
> > > > commit 5b251c6315097d5f9ab5d30c43813fe74c1db4e4
> > > > tree 5ca21582f55886d5f0249f7ca139687450024581
> > > > parent e44ccdabb97fa4a6cdc1a95adcad7bcc469d0c16
> > > > author Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200
> > > > committer Pavel <pavel@amd.ucw.cz> Mon, 05 May 2008 22:08:51 +0200
> > > 
> > > Let me guess, you're using git-am too? :P
> > 
> > No, this is actually all hand-generated ;-).
> 
> Seriously though, we (as inhabitants of linux-wireless) have no context
> for these patches, so I hope you're not expecting us to actually look at
> them.

I mainly want them archived at public place, and maybe let others know
that I'm working on this.

Context is at http://code.google.com/p/winbondport/ . I hope to get
something that can be merged one day; any help with cleaning the code
is very welcome.

I believe code is now in shape where it can be incrementally cleaned
up for a merge, then features can be added back... (Currently it is
locked to single channel at single speed).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
