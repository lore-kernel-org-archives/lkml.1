Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbYLKW5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbYLKW5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbYLKW5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:57:33 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45620 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758113AbYLKW5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:57:32 -0500
Date: Thu, 11 Dec 2008 17:57:23 -0500
From: Theodore Tso <tytso@mit.edu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081211225723.GD10890@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Joerg Roedel <joro@8bytes.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <20081211084058.GE24323@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211084058.GE24323@8bytes.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 09:40:58AM +0100, Joerg Roedel wrote:
> On Wed, Dec 10, 2008 at 05:04:39PM -0800, Linus Torvalds wrote:
> > 
> >  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> > 
> >      I like this, because alledgely people are debugging things, and we'd 
> >      get a more stable 2.6.28.
> >
> 
> I'll vote for a. An open merge window over the holidays possible results
> in needless stresses for the developers at a time which some of them
> want to use otherwise. Or if any merge introduces bad bugs and the
> developers that can fix it are on xmax vacation we may end up with an
> unusable upstream tree for a week or so. Same with merge conflicts.
> So, I'd suggest to wait until everybody is back to work until opening
> the merge window.

I'd vote for (a) as well, and hopefully folks who are really
conscientious can do some integration testing of linux-next and can
report problems there to make the merge window go more smoothly after
the New Year's.

							- Ted
