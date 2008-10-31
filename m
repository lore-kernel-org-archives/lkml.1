Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYJaDcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYJaDcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 23:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYJaDb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 23:31:56 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53071 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914AbYJaDbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 23:31:55 -0400
Date: Thu, 30 Oct 2008 23:31:50 -0400
From: Theodore Tso <tytso@mit.edu>
To: "J.R. Mauro" <jrm8005@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: merging other repos into linux-2.6
Message-ID: <20081031033150.GC9781@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"J.R. Mauro" <jrm8005@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20081030054944.GA19035@kroah.com> <3aaafc130810301834w554fbd33p6f423ffef77e92aa@mail.gmail.com> <alpine.LFD.2.00.0810301843220.21084@nehalem.linux-foundation.org> <3aaafc130810301938k4ee654d6sf7de1fff5d9c9fc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aaafc130810301938k4ee654d6sf7de1fff5d9c9fc3@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:38:36PM -0400, J.R. Mauro wrote:
> And the willingness to put in the effort may be there now, but what
> I'm worried about is 6 months from now, when everyone who has an
> out-of-tree driver wants history imported because "well, you did it
> for the Comedi guys". Greg is a pretty busy guy, and we don't want him
> buried under something like that, especially if the payoff is
> marginal.

Greg's a big boy and he can decide what he wants to do with his own
time --- but what I'd recommend is that if "other projects" want to
merge their history, it should be up to the upstream projects to
massage their git history into something that his suitable for
merging.  It doesn't scale to have core maintainers doing heavy-duty
git history rewrites for everybody else.  Of course, if someone wants
to volunteer their time to help other projects do this, that's
completely up to them.

	    	  	 	       	  - Ted
