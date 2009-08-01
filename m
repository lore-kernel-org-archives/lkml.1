Return-Path: <linux-kernel-owner+w=401wt.eu-S1752554AbZHAW0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbZHAW0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 18:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZHAW0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 18:26:50 -0400
Received: from thunk.org ([69.25.196.29]:49612 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZHAW0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 18:26:49 -0400
Date: Sat, 1 Aug 2009 18:26:37 -0400
From: Theodore Tso <tytso@mit.edu>
To: Daniel Phillips <phillips@phunq.net>
Cc: debian developer <debiandev@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, tux3@tux3.org,
       LKML <linux-kernel@vger.kernel.org>, corbet@lwn.net
Subject: Re: [Tux3] Current Activities?
Message-ID: <20090801222637.GA8680@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Daniel Phillips <phillips@phunq.net>,
	debian developer <debiandev@gmail.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, tux3@tux3.org,
	LKML <linux-kernel@vger.kernel.org>, corbet@lwn.net
References: <6dcc37b30904291901m7abdd6d7q6f44b2c248ec48c4@mail.gmail.com> <200904302049.27235.phillips@phunq.net> <f24d23310907310210w4406f596nc5b85a7ff41ee40c@mail.gmail.com> <200908010942.52623.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908010942.52623.phillips@phunq.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 01, 2009 at 09:42:51AM -0700, Daniel Phillips wrote:
> Shapor maintains our website, which does have a wiki.  Just ping him on
> irc about it.

Free hint: make a pointer to the wiki be much more prominent on the
tux3.org web site.  I tried looking for it on the tux3 web site, and
then on google, and the closest thing I could find was this empty wiki:

     http://bitbucket.org/shapor/tux3/wiki/Home

One thing which you might want to include is what makes the tux3 file
system unique and why someone might want to use tux3 instead of some
other file system?  The web site talks about "versioned pointer" which
is a technical feature that might appeal to a computer scientist ---
but what does that mean to an end user?

Performance?  Features?  If so, which features?  From what I can tell,
the feature set of tux3 seems to be a subset of btrfs; is there some
feature or features that tux3 have that other filesystems will not?
Not that I advocate file system developers throwing elbows or
otherwise being too competitive with each other, but the reality is
that every file system design makes tradeoffs, giving it certain
strengths, and some weaknesses.  So what *is* tux3's core design
focus, in terms of workload, or user base?  Making a clear statement
about what the goals of the tux3 filesystem on the web site is
certainly one of those things that I would recommend.

Best regards,

					- Ted
